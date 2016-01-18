require 'rails_helper'

RSpec.describe FollowsRules do
  fixtures :cards

  let(:game) { Game.create!(trump_card: cards(:hearts_6))}

  let!(:attacker) { game.players.create! }
  let!(:defender) { game.players.create! }

  let(:game_state) { BuildGameState.new(game).call }

  describe "#call" do

    context "it is not this player's turn" do
      before do
        attacker.steps.create!(kind: :deal, card: cards(:hearts_10))
        attacker.steps.create!(kind: :deal, card: cards(:spades_7))

        defender.steps.create!(kind: :deal, card: cards(:spades_8))
        defender.steps.create!(kind: :deal, card: cards(:spades_9))
      end

      context "start of game (no attack moves made yet)" do
        it "defender tries to attack and fails rules" do
          illegal_step = defender.steps.create!(kind: :attack, card: cards(:spades_8))

          expect(FollowsRules.new(illegal_step, game_state, game).call).to eq false
        end
      end

      context "mid-turn (an attack move has been made)" do
        before do
          attacker.steps.create!(kind: :attack, card: cards(:spades_7))
        end

        it "the attacker tries to move for the second time in a row and fails rules" do
          illegal_step = attacker.steps.create!(kind: :attack, card: cards(:hearts_10))

          expect(FollowsRules.new(illegal_step, game_state, game).call).to eq false
        end

        it "the defender tries to attack and fails rules" do
          illegal_step = defender.steps.create!(kind: :attack, card: cards(:spades_9))

          expect(FollowsRules.new(illegal_step, game_state, game).call).to eq false
        end
      end
    end

    context "it is this player's turn" do
      before do
        attacker.steps.create!(kind: :deal, card: cards(:hearts_10))
        attacker.steps.create!(kind: :deal, card: cards(:spades_7))
        attacker.steps.create!(kind: :deal, card: cards(:clubs_9))

        defender.steps.create!(kind: :deal, card: cards(:spades_6))
        defender.steps.create!(kind: :deal, card: cards(:spades_9))
        defender.steps.create!(kind: :deal, card: cards(:diamonds_9))
      end

      context "second turn of the game" do
        before do
          attacking_step = attacker.steps.create!(kind: :attack, card: cards(:spades_7))
          defender.steps.create!(kind: :defend, card: cards(:spades_9), in_response_to_step: attacking_step)

          attacker.steps.create!(kind: :discard)
        end

        context "the defender drew from the deck and became the attacker" do
          before do
            attacker.steps.create!(kind: :draw_from_deck, card: cards(:hearts_11))

            defender.steps.create!(kind: :draw_from_deck, card: cards(:spades_10))
          end

          it "old defender (now atacker) tries to attack and passes rules" do
            legal_step = defender.steps.create!(kind: :attack, card: cards(:spades_10))

            expect(FollowsRules.new(legal_step, game_state, game).call).to eq true
          end
        end
      end

      context "the step kind is defend" do
        before do
          attacker.steps.create!(kind: :attack, card: cards(:spades_7))
        end

        it "the defending suit and rank abide by rules (rules pass)" do
          defend_step = defender.steps.create!(kind: :defend, card: cards(:spades_9), in_response_to_step: game.steps.last )

          expect(FollowsRules.new(defend_step, game_state, game).call).to eq true
        end

        it "the defending suit abides by rules, but the rank does not so rules fail" do
          defend_step = defender.steps.create!(kind: :defend, card: cards(:spades_6), in_response_to_step: game.steps.last )

          expect(FollowsRules.new(defend_step, game_state, game).call).to eq false
        end

        it "the defending rank abides by rules, but suit does not so rules fail" do
          defend_step = defender.steps.create!(kind: :defend, card: cards(:diamonds_9), in_response_to_step: game.steps.last )

          expect(FollowsRules.new(defend_step, game_state, game).call).to eq false
        end

        context "the attacking card is a non-trump ace" do
          before do
            attacker.steps.create!(kind: :draw_from_deck, card: cards(:diamonds_14))
            defender.steps.create!(kind: :draw_from_deck, card: cards(:hearts_7))

            attacker.steps.create!(kind: :attack, card: cards(:diamonds_14))
          end

          it "the defending suit and rank abide by rules due to being a trump" do
            defend_step = defender.steps.create!(kind: :defend, card: cards(:hearts_7), in_response_to_step: game.steps.last )

            expect(FollowsRules.new(defend_step, game_state, game).call).to eq true
          end
        end

        context "the attacking card is a trump" do
          before do
            attacker.steps.create!(kind: :draw_from_deck, card: cards(:hearts_8))
            defender.steps.create!(kind: :draw_from_deck, card: cards(:hearts_7))
            defender.steps.create!(kind: :draw_from_deck, card: cards(:hearts_9))

            attacker.steps.create!(kind: :attack, card: cards(:hearts_8))
          end

          it "the defending suit and rank abide by rules" do
            defend_step = defender.steps.create!(kind: :defend, card: cards(:hearts_9), in_response_to_step: game.steps.last )

            expect(FollowsRules.new(defend_step, game_state, game).call).to eq true
          end

          it "the defending suit abides by rules, but rank does not" do
            defend_step = defender.steps.create!(kind: :defend, card: cards(:hearts_7), in_response_to_step: game.steps.last )

            expect(FollowsRules.new(defend_step, game_state, game).call).to eq false
          end
        end
      end

      context "the step kind is attack" do
        before do
          attacker.steps.create!(kind: :attack, card: cards(:spades_7))
        end

        it "the first attack of the turn passes the rules" do
          expect(FollowsRules.new(game.steps.last, game_state, game).call).to eq true
        end

        context "subsequent attacks" do
          before do
            defender.steps.create!(kind: :defend, card: cards(:spades_9), in_response_to_step: game.steps.last )
          end

          it "the attacking rank abides by the rules" do
            next_attack_step = attacker.steps.create!(kind: :attack, card: cards(:clubs_9))

            expect(FollowsRules.new(next_attack_step, game_state, game).call).to eq true
          end

          it "the attacking rank does not abide by the rules" do
            next_attack_step = attacker.steps.create!(kind: :attack, card: cards(:hearts_10))

            expect(FollowsRules.new(next_attack_step, game_state, game).call).to eq false
          end

          context "there are not enough cards in defender's hand to defend" do
            before do
              defender.steps.where(kind: "deal", card: cards(:spades_6)).destroy_all
              defender.steps.where(kind: "deal", card: cards(:diamonds_9)).destroy_all
            end

            it "the defender may not attack, even if the attacking card rank abides by rules" do
              next_attack_step = attacker.steps.create!(kind: :attack, card: cards(:clubs_9))

              expect(FollowsRules.new(next_attack_step, game_state, game).call).to eq false
            end
          end
        end
      end
    end
  end
end
