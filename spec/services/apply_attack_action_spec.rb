require 'rails_helper'

RSpec.describe ApplyAttackAction do
  fixtures :cards

  let(:card) { cards(:hearts_7) }
  let(:game) { Game.create!(:trump_card => card) }
  let!(:player_one) { Player.create!(:game => game) }
  let!(:player_two) { Player.create!(:game => game) }
  let(:initial_game_state) { GameState.base_state(game) }

  describe "#call" do
    context "when the card is not in player one's hand" do
      let(:attack_action) { Action.new(:kind => :attack, :active_card => card, :initiating_player => player_one) }

      subject { ApplyAttackAction.new(initial_game_state, attack_action) }

      it "raises error" do
        expect{ subject.call }.to raise_error("Card must be in player's hand to attack")
      end
    end

    context "when the card is in player one's hand" do
      let(:attack_action) { Action.new(:kind => :attack, :active_card => card, :initiating_player => player_one) }

      before do
        initial_game_state.deck.delete(card)
        initial_game_state.player_hand(1).add(card)
      end

      it "moves the card to the table" do
        game_state = ApplyAttackAction.new(initial_game_state, attack_action).call
        expect(game_state.table).to include card
      end

      it "moves the card out of the player's hand" do
        game_state = ApplyAttackAction.new(initial_game_state, attack_action).call
        expect(game_state.player_hand(1)).not_to include card
      end
    end

    context "when the card is not in player two's hand" do
      let(:attack_action) { Action.new(:kind => :attack, :active_card => card, :initiating_player => player_two) }

      subject { ApplyAttackAction.new(initial_game_state, attack_action) }

      it "raises error" do
        expect{ subject.call }.to raise_error("Card must be in player's hand to attack")
      end
    end

    context "when the card is in player two's hand" do
      let(:attack_action) { Action.new(:kind => :attack, :active_card => card, :initiating_player => player_two) }

      before do
        initial_game_state.deck.delete(card)
        initial_game_state.player_hand(2).add(card)
      end

      it "moves the card to the table" do
        game_state = ApplyAttackAction.new(initial_game_state, attack_action).call
        expect(game_state.table).to include card
      end

      it "moves the card out of the player's hand" do
        game_state = ApplyAttackAction.new(initial_game_state, attack_action).call
        expect(game_state.player_hand(2)).not_to include card
      end
    end
  end
end
