require 'rails_helper'
require 'test_game'

RSpec.describe BuildGameState do
  fixtures :cards

  let(:trump_card) { cards(:spades_10) }
  let(:test_game) { TestGame.new(trump_card) }
  subject(:game_state) { BuildGameState.new(test_game.game_model).call }

  context "when no steps have been applied" do
    it "returns GameState with trump_card from game" do
      expect(subject.trump_card).to eq test_game.trump_card
    end

    it "returns GameState with all cards in deck location" do
      expect(subject.deck).to include(*Card.all)
    end

    it "returns GameState with players" do
      expect(subject.player_states).to_not be_empty
    end
  end
end
