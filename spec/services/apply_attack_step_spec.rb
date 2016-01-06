require 'rails_helper'

RSpec.describe ApplyAttackStep do
  fixtures :cards

  let(:game) { Game.create!(trump_card: cards(:hearts_12)) }
  let!(:attacker) { game.players.create! }
  let!(:defender) { game.players.create! }

  let(:attacking_card) { cards(:spades_9) }

  let(:attack_step) { instance_double(Step) }
  before do
    allow(attack_step).to receive(:card).and_return(attacking_card)
    allow(attack_step).to receive(:player).and_return(attacker)
  end

  let(:game_state) { BuildGameState.new(game).call }
  subject { ApplyAttackStep.new(game_state, attack_step).call }
  let(:attacker_state) { game_state.player_state_for_player(attacker) }

  describe "#call" do
    context "when the attacking card is not in the attacker's hand" do
      it "raises error" do
        expect{ subject }.to raise_error("Card must be in player's hand to attack")
      end
    end

    context "when the card is in the attacker's hand" do
      before do
        fill_hand_from_deck(attacker_state, attacking_card)
      end

      it "moves the card to the table" do
        expect(subject.table).to include attacking_card
      end

      it "moves the card out of the attacker's hand" do
        attacker_state = subject.player_state_for_player(attacker)
        expect(attacker_state.hand).not_to include attacking_card
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
