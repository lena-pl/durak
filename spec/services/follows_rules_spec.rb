require 'rails_helper'

RSpec.describe FollowsRules do
  fixtures :cards

  let(:game) { Game.create!(trump_card: cards(:hearts_6))}

  let!(:attacker) { game.players.create! }
  let!(:defender) { game.players.create! }

  let(:game_state) { BuildGameState.new(game).call }

  describe "#call" do

    context "it is not this player's turn" do
      context "start of game" do
        let!(:step_1) { defender.steps.create!(kind: :draw_from_deck, card: cards(:spades_7)) }

        let!(:step_2) { attacker.steps.create!(kind: :draw_from_deck, card: cards(:spades_8)) }
        let!(:step_3) { attacker.steps.create!(kind: :draw_from_deck, card: cards(:hearts_10)) }

        let(:illegal_step) { defender.steps.create!(kind: :attack, card: cards(:spades_7)) }

        it "does not pass rules" do
          expect(FollowsRules.new(illegal_step, game_state, game).call).to eq false
        end
      end

      context "mid-turn" do
        let!(:step_1) { attacker.steps.create!(kind: :draw_from_deck, card: cards(:spades_7)) }
        let!(:step_2) { attacker.steps.create!(kind: :draw_from_deck, card: cards(:spades_8)) }
        let!(:step_3) { attacker.steps.create!(kind: :draw_from_deck, card: cards(:hearts_10)) }

        let!(:step_4) { defender.steps.create!(kind: :draw_from_deck, card: cards(:spades_9)) }

        context "the attacker tries to move twice in a row" do
          let!(:attack_step) { attacker.steps.create!(kind: :attack, card: cards(:spades_7)) }

          let(:illegal_step) { attacker.steps.create!(kind: :attack, card: cards(:spades_8)) }

          it "does not pass rules" do
            expect(FollowsRules.new(illegal_step, game_state, game).call).to eq false
          end
        end

        context "the defender tries to attack" do
          let(:illegal_step) { defender.steps.create!(kind: :attack, card: cards(:spades_9)) }

          it "does not pass rules" do
            expect(FollowsRules.new(illegal_step, game_state, game).call).to eq false
          end
        end

      end
    end

    context "it is this player's turn" do
      context "the defender drew from the deck, became the attacker and tries to make a move" do
        let(:legal_step) { defender.steps.create!(kind: :attack, card: cards(:spades_9)) }

        it "passes rules" do
          attacker.steps.create!(kind: :deal, card: cards(:spades_7))
          attacker.steps.create!(kind: :deal, card: cards(:hearts_11))
          step_2 = attacker.steps.create!(kind: :attack, card: cards(:spades_7))

          defender.steps.create!(kind: :draw_from_deck, card: cards(:spades_8))
          defender.steps.create!(kind: :defend, card: cards(:spades_8), in_response_to_step: step_2)

          attacker.steps.create!(kind: :discard)

          attacker.steps.create!(kind: :draw_from_deck, card: cards(:hearts_10))

          defender.steps.create!(kind: :draw_from_deck, card: cards(:spades_9))

          expect(FollowsRules.new(legal_step, game_state, game).call).to eq true
        end
      end

      context "the step kind is defend" do
        context "the defending suit and rank abide by rules" do
          let!(:step_1) { attacker.steps.create!(kind: :draw_from_deck, card: cards(:spades_7)) }

          let!(:step_4) { defender.steps.create!(kind: :draw_from_deck, card: cards(:spades_9)) }

          let!(:attack_step) { attacker.steps.create!(kind: :attack, card: cards(:spades_7)) }
          let(:defend_step) { defender.steps.create!(kind: :defend, card: cards(:spades_9), in_response_to_step: attack_step ) }

          it "passes the rules" do
            expect(FollowsRules.new(defend_step, game_state, game).call).to eq true
          end
        end

        context "the defending suit abides by rules, but the rank does not" do
          let!(:step_1) { attacker.steps.create!(kind: :draw_from_deck, card: cards(:spades_10)) }

          let!(:step_2) { defender.steps.create!(kind: :draw_from_deck, card: cards(:spades_8)) }

          let!(:attack_step) { attacker.steps.create!(kind: :attack, card: cards(:spades_10)) }
          let!(:defend_step) { defender.steps.create!(kind: :defend, card: cards(:spades_8), in_response_to_step: attack_step ) }

          it "does not pass rules" do
            expect(FollowsRules.new(defend_step, game_state, game).call).to eq false
          end
        end

        context "the defending rank abides by rules, but suit does not" do
          let!(:step_1) { attacker.steps.create!(kind: :draw_from_deck, card: cards(:diamonds_7)) }

          let!(:step_2) { defender.steps.create!(kind: :draw_from_deck, card: cards(:spades_12)) }

          let(:attack_step) { attacker.steps.create!(kind: :attack, card: cards(:diamonds_7)) }
          let(:defend_step) { defender.steps.create!(kind: :defend, card: cards(:spades_12), in_response_to_step: attack_step ) }

          it "does not pass rules" do
            expect(FollowsRules.new(defend_step, game_state, game).call).to eq false
          end
        end

        context "the defending suit and rank abide by rules due to being a trump" do
          let!(:step_1) { attacker.steps.create!(kind: :draw_from_deck, card: cards(:diamonds_14)) }

          let!(:step_2) { defender.steps.create!(kind: :draw_from_deck, card: cards(:hearts_8)) }

          let(:attack_step) { attacker.steps.create!(kind: :attack, card: cards(:diamonds_14)) }
          let(:defend_step) { defender.steps.create!(kind: :defend, card: cards(:hearts_8), in_response_to_step: attack_step ) }

          it "passes the rules" do
            expect(FollowsRules.new(defend_step, game_state, game).call).to eq true
          end
        end

        context "the attacking card is a trump and the defending suit and rank abide by rules" do
          let!(:step_1) { attacker.steps.create!(kind: :draw_from_deck, card: cards(:hearts_8)) }

          let!(:step_2) { defender.steps.create!(kind: :draw_from_deck, card: cards(:hearts_9)) }

          let(:attack_step) { attacker.steps.create!(kind: :attack, card: cards(:hearts_8)) }
          let(:defend_step) { defender.steps.create!(kind: :defend, card: cards(:hearts_9), in_response_to_step: attack_step ) }

          it "passes the rules" do
            expect(FollowsRules.new(defend_step, game_state, game).call).to eq true
          end
        end

        context "the attacking card is a trump and the defending suit abides by rules, but rank does not" do
          let!(:step_1) { attacker.steps.create!(kind: :draw_from_deck, card: cards(:hearts_8)) }

          let!(:step_2) { defender.steps.create!(kind: :draw_from_deck, card: cards(:hearts_7)) }

          let(:attack_step) { attacker.steps.create!(kind: :attack, card: cards(:hearts_8)) }
          let(:defend_step) { defender.steps.create!(kind: :defend, card: cards(:hearts_7), in_response_to_step: attack_step ) }

          it "does not pass the rules" do
            expect(FollowsRules.new(defend_step, game_state, game).call).to eq false
          end
        end
      end

      context "the step kind is attack" do
        context "the first attack of the turn" do
          let!(:step_1) { defender.steps.create!(kind: :deal, card: cards(:spades_8)) }

          let!(:step_2) { attacker.steps.create!(kind: :deal, card: cards(:spades_7)) }

          let(:attack_step) { attacker.steps.create!(kind: :attack, card: cards(:spades_7)) }

          it "passes the rules" do
            expect(FollowsRules.new(attack_step, game_state, game).call).to eq true
          end
        end

        context "subsequent attacks" do
          context "the attacking rank abides by the rules" do
            let!(:step_0) { attacker.steps.create!(kind: :deal, card: cards(:hearts_8)) }
            let!(:step_1) { attacker.steps.create!(kind: :draw_from_deck, card: cards(:spades_7)) }
            let!(:step_2) { attacker.steps.create!(kind: :draw_from_deck, card: cards(:diamonds_7)) }

            let!(:step_3) { defender.steps.create!(kind: :draw_from_deck, card: cards(:spades_8)) }
            let!(:step_4) { defender.steps.create!(kind: :draw_from_deck, card: cards(:spades_10)) }

            let!(:attack_step) { attacker.steps.create!(kind: :attack, card: cards(:spades_7)) }
            let!(:defend_step) { defender.steps.create!(kind: :defend, card: cards(:spades_8), in_response_to_step: attack_step ) }
            let(:next_attack_step) { attacker.steps.create!(kind: :attack, card: cards(:diamonds_7)) }

            it "passes the rules" do
              expect(FollowsRules.new(next_attack_step, game_state, game).call).to eq true
            end
          end

          context "the attacking rank does not abide by the rules" do
            let!(:step_1) { attacker.steps.create!(kind: :draw_from_deck, card: cards(:spades_7)) }
            let!(:step_2) { attacker.steps.create!(kind: :draw_from_deck, card: cards(:diamonds_12)) }

            let!(:step_3) { defender.steps.create!(kind: :draw_from_deck, card: cards(:spades_8)) }
            let!(:step_4) { defender.steps.create!(kind: :draw_from_deck, card: cards(:spades_10)) }

            let!(:attack_step) { attacker.steps.create!(kind: :attack, card: cards(:spades_7)) }
            let!(:defend_step) { defender.steps.create!(kind: :defend, card: cards(:spades_8), in_response_to_step: attack_step ) }
            let(:next_attack_step) { attacker.steps.create!(kind: :attack, card: cards(:diamonds_12)) }

            it "does not pass the rules" do
              expect(FollowsRules.new(next_attack_step, game_state, game).call).to eq false
            end
          end

          context "there are not enough cards in defender's hand to defend" do
            let!(:step_1) { attacker.steps.create!(kind: :draw_from_deck, card: cards(:spades_7)) }
            let!(:step_2) { attacker.steps.create!(kind: :draw_from_deck, card: cards(:diamonds_7)) }

            let!(:step_3) { defender.steps.create!(kind: :draw_from_deck, card: cards(:spades_8)) }

            let!(:attack_step) { attacker.steps.create!(kind: :attack, card: cards(:spades_7)) }
            let!(:defend_step) { defender.steps.create!(kind: :defend, card: cards(:spades_8), in_response_to_step: attack_step ) }
            let(:next_attack_step) { attacker.steps.create!(kind: :attack, card: cards(:diamonds_7)) }

            it "does not pass the rules" do
              expect(FollowsRules.new(next_attack_step, game_state, game).call).to eq false
            end
          end
        end
      end
    end
  end

  def take_step(player, kind, card, in_response_to_step = nil)
    player.steps.create!(kind: kind, card: card, in_response_to_step: in_response_to_step)
  end
end
