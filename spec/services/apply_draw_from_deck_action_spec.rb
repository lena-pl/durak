require 'rails_helper'

RSpec.describe ApplyDrawFromDeckAction do
  fixtures :cards

  let(:card) { cards(:hearts_7) }
  let(:game) { Game.create!(:trump_card => card) }
  let!(:player_one) { Player.create!(:game => game) }
  let!(:player_two) { Player.create!(:game => game) }
  let(:base_game_state) { BuildGameState.new(game).call }

  describe "#call" do
    context "player one draws a card from the deck" do
      let(:draw_from_deck_action) { Action.new(:kind => :draw_from_deck, :card => card, :player => player_one) }

      it "moves the card to player one's hand" do
        game_state = ApplyDrawFromDeckAction.new(base_game_state, draw_from_deck_action).call
        expect(game_state.player_hand(1).include?(card)).to be_truthy
      end

      it "moves the card out of deck" do
        game_state = ApplyDrawFromDeckAction.new(base_game_state, draw_from_deck_action).call
        expect(game_state.deck.include?(card)).to be_falsey
      end
    end

    context "player two draws a card from the deck" do
      let(:draw_from_deck_action) { Action.new(:kind => :draw_from_deck, :card => card, :player => player_two) }

      it "moves the card to player two's hand" do
        game_state = ApplyDrawFromDeckAction.new(base_game_state, draw_from_deck_action).call
        expect(game_state.player_hand(2).include?(card)).to be_truthy
      end

      it "moves the card out of deck" do
        game_state = ApplyDrawFromDeckAction.new(base_game_state, draw_from_deck_action).call
        expect(game_state.deck.include?(card)).to be_falsey
      end
    end
  end
end
