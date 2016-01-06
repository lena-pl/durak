require 'rails_helper'

RSpec.describe FollowsRules do
  fixtures :cards

  let(:game) { Game.create!(trump_card: cards(:hearts_6))}

  let!(:attacker) { game.players.create! }
  let(:attacker_state) { game_state.player_state_for_player(attacker) }

  let!(:defender) { game.players.create! }
  let(:defender_state) { game_state.player_state_for_player(defender) }

  let(:game_state) { BuildGameState.new(game).call }

  describe "#call" do
    before do
      fill_hand_from_deck(attacker_state, *attacker_hand)
      fill_hand_from_deck(defender_state, *defender_hand)
    end

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
          expect(FollowsRules.new(defend_step, game_state).call).to eq true
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
          expect(FollowsRules.new(defend_step, game_state).call).to eq false
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
          expect(FollowsRules.new(defend_step, game_state).call).to eq false
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
          expect(FollowsRules.new(defend_step, game_state).call).to eq true
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
