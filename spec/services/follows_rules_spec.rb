require 'rails_helper'

RSpec.describe FollowsRules do
  fixtures :cards

  let(:game) { Game.create!(trump_card: cards(:hearts_6))}

  let!(:attacker) { game.players.create! }
  let!(:defender) { game.players.create! }

  let(:game_state) { BuildGameState.new(game).call }
  let!(:attacker_state) { game_state.player_state_for_player(attacker) }
  let!(:defender_state) { game_state.player_state_for_player(defender) }

  describe "#call" do
    before do
      fill_hand_from_deck(attacker_state, *attacker_hand)
      fill_hand_from_deck(defender_state, *defender_hand)
      game_state.attacker = attacker
    end

    context "it is not this player's turn" do
      context "start of game" do
        let(:defender_hand) do
          [cards(:spades_7)]
        end

        let(:attacker_hand) do
          [cards(:spades_8)]
        end

        let(:illegal_step) { defender.steps.create!(kind: :attack, card: cards(:spades_7)) }

        it "does not pass rules" do
          expect(FollowsRules.new(illegal_step, game_state, game).call).to eq false
        end
      end

      context "mid-turn" do
        let(:attacker_hand) do
          [cards(:spades_7),
           cards(:spades_8)]
        end

        let(:defender_hand) do
          [cards(:spades_9)]
        end

        context "the attacker tries to move twice in a row" do
          let!(:attack_step) { attacker.steps.create!(kind: :attack, card: cards(:spades_7)) }
          let!(:illegal_step) { attacker.steps.create!(kind: :attack, card: cards(:spades_8)) }

          it "does not pass rules" do
            expect(FollowsRules.new(illegal_step, game_state, game).call).to eq false
          end
        end

        context "the defender tries to attack" do
          let!(:illegal_step) { defender.steps.create!(kind: :attack, card: cards(:spades_9)) }

          it "does not pass rules" do
            expect(FollowsRules.new(illegal_step, game_state, game).call).to eq false
          end
        end

        context "the defender tries to defend prematurely" do
          let!(:draw_step) { defender.steps.create!(kind: :draw_from_deck, card: cards(:spades_6)) }
          let!(:draw_step) { attacker.steps.create!(kind: :draw_from_deck, card: cards(:spades_10)) }
          let!(:illegal_step) { defender.steps.create!(kind: :defend, card: cards(:spades_9), in_response_to_step: draw_step) }

          it "does not pass rules" do
            expect(FollowsRules.new(illegal_step, game_state, game).call).to eq false
          end
        end

        context "the attacker drew from the deck, but the defender tries to make a move" do
          let!(:draw_step) { attacker.steps.create!(kind: :draw_from_deck, card: cards(:spades_10)) }
          let!(:illegal_step) { defender.steps.create!(kind: :attack, card: cards(:spades_9)) }

          it "does not pass rules" do
            expect(FollowsRules.new(illegal_step, game_state, game).call).to eq false
          end
        end
      end
    end

    context "it is this player's turn" do

      context "the step kind is defend" do
        context "the defending suit and rank abide by rules" do
          let(:defender_hand) do
            [cards(:spades_8)]
          end

          let(:attacker_hand) do
            [cards(:spades_7)]
          end

          let(:attack_step) { attacker.steps.create!(kind: :attack, card: cards(:spades_7)) }
          let(:defend_step) { defender.steps.create!(kind: :defend, card: cards(:spades_8), in_response_to_step: attack_step ) }

          it "passes the rules" do
            expect(FollowsRules.new(defend_step, game_state, game).call).to eq true
          end
        end

        context "the defending suit abides by rules, but the rank does not" do
          let(:defender_hand) do
            [cards(:spades_8)]
          end

          let(:attacker_hand) do
            [cards(:spades_10)]
          end

          let(:attack_step) { attacker.steps.create!(kind: :attack, card: cards(:spades_10)) }
          let(:defend_step) { defender.steps.create!(kind: :defend, card: cards(:spades_8), in_response_to_step: attack_step ) }

          it "does not pass rules" do
            expect(FollowsRules.new(defend_step, game_state, game).call).to eq false
          end
        end

        context "the defending rank abides by rules, but suit does not" do
          let(:defender_hand) do
            [cards(:spades_12)]
          end

          let(:attacker_hand) do
            [cards(:diamonds_7)]
          end

          let(:attack_step) { attacker.steps.create!(kind: :attack, card: cards(:diamonds_7)) }
          let(:defend_step) { defender.steps.create!(kind: :defend, card: cards(:spades_12), in_response_to_step: attack_step ) }

          it "does not pass rules" do
            expect(FollowsRules.new(defend_step, game_state, game).call).to eq false
          end
        end

        context "the defending suit and rank abide by rules due to being a trump" do
          let(:defender_hand) do
            [cards(:hearts_8)]
          end

          let(:attacker_hand) do
            [cards(:diamonds_14)]
          end

          let(:attack_step) { attacker.steps.create!(kind: :attack, card: cards(:diamonds_14)) }
          let(:defend_step) { defender.steps.create!(kind: :defend, card: cards(:hearts_8), in_response_to_step: attack_step ) }

          it "passes the rules" do
            expect(FollowsRules.new(defend_step, game_state, game).call).to eq true
          end
        end

        context "the attacking card is a trump and the defending suit and rank abide by rules" do
          let(:defender_hand) do
            [cards(:hearts_8)]
          end

          let(:attacker_hand) do
            [cards(:hearts_9)]
          end

          let(:attack_step) { attacker.steps.create!(kind: :attack, card: cards(:hearts_8)) }
          let(:defend_step) { defender.steps.create!(kind: :defend, card: cards(:hearts_9), in_response_to_step: attack_step ) }

          it "passes the rules" do
            expect(FollowsRules.new(defend_step, game_state, game).call).to eq true
          end
        end

        context "the attacking card is a trump and the defending suit abides by rules, but rank does not" do
          let(:defender_hand) do
            [cards(:hearts_8)]
          end

          let(:attacker_hand) do
            [cards(:hearts_7)]
          end

          let(:attack_step) { attacker.steps.create!(kind: :attack, card: cards(:hearts_8)) }
          let(:defend_step) { defender.steps.create!(kind: :defend, card: cards(:hearts_7), in_response_to_step: attack_step ) }

          it "does not pass the rules" do
            expect(FollowsRules.new(defend_step, game_state, game).call).to eq false
          end
        end
      end

      context "the step kind is attack" do
        context "the first attack of the turn" do
          let(:attacker_hand) do
            [cards(:spades_7)]
          end

          let(:defender_hand) do
            [cards(:spades_8)]
          end

          let(:attack_step) { attacker.steps.create!(kind: :attack, card: cards(:spades_7)) }

          it "passes the rules" do
            expect(FollowsRules.new(attack_step, game_state, game).call).to eq true
          end
        end

        context "subsequent attacks" do
          context "the attacking rank abides by the rules" do
            let(:attacker_hand) do
              [cards(:spades_7),
               cards(:diamonds_7)]
            end

            let(:defender_hand) do
              [cards(:spades_8),
               cards(:spades_10)]
            end

            let!(:attack_step) { attacker.steps.create!(kind: :attack, card: cards(:spades_7)) }
            let!(:defend_step) { defender.steps.create!(kind: :defend, card: cards(:spades_8), in_response_to_step: attack_step ) }
            let!(:next_attack_step) { attacker.steps.create!(kind: :attack, card: cards(:diamonds_7)) }

            it "passes the rules" do
              ApplyAttackStep.new(game_state, attack_step).call
              ApplyDefendStep.new(game_state, defend_step).call
              expect(FollowsRules.new(next_attack_step, game_state, game).call).to eq true
            end
          end

          context "the attacking rank does not abide by the rules" do
            let(:attacker_hand) do
              [cards(:spades_7),
               cards(:diamonds_12)]
            end

            let(:defender_hand) do
              [cards(:spades_8),
               cards(:spades_10)]
            end

            let!(:attack_step) { attacker.steps.create!(kind: :attack, card: cards(:spades_7)) }
            let!(:defend_step) { defender.steps.create!(kind: :defend, card: cards(:spades_8), in_response_to_step: attack_step ) }
            let!(:next_attack_step) { attacker.steps.create!(kind: :attack, card: cards(:diamonds_12)) }

            it "does not pass the rules" do
              ApplyAttackStep.new(game_state, attack_step).call
              ApplyDefendStep.new(game_state, defend_step).call
              expect(FollowsRules.new(next_attack_step, game_state, game).call).to eq false
            end
          end

          context "there are not enough cards in defender's hand to defend" do
            let(:attacker_hand) do
              [cards(:spades_7),
               cards(:diamonds_7)]
            end

            let(:defender_hand) do
              [cards(:spades_8)]
            end

            let!(:attack_step) { attacker.steps.create!(kind: :attack, card: cards(:spades_7)) }
            let!(:defend_step) { defender.steps.create!(kind: :defend, card: cards(:spades_8), in_response_to_step: attack_step ) }
            let!(:next_attack_step) { attacker.steps.create!(kind: :attack, card: cards(:diamonds_7)) }

            it "does not pass the rules" do
              ApplyAttackStep.new(game_state, attack_step).call
              ApplyDefendStep.new(game_state, defend_step).call
              expect(FollowsRules.new(next_attack_step, game_state, game).call).to eq false
            end
          end
        end
      end
    end
  end

  def fill_hand_from_deck(player_state, *cards)
    cards.each { |card| move_from_deck_to(player_state, card) }
  end

  def move_from_deck_to(player_state, card)
    game_state.deck.delete(card)
    player_state.hand.push(card)
  end
end
