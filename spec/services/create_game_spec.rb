require 'rails_helper'

RSpec.describe CreateGame do
  describe "#call" do
    subject(:game) { CreateGame.new(session: { "player_token" => SecureRandom.hex }).call }

    it "creates a game" do
      expect(game).to eq Game.last
    end

    it "creates 2 players" do
      expect(game.players.count).to eq 2
    end

    let(:game_state) { BuildGameState.new(game).call }

    it "deals the cards to the players" do
      expect(game_state.deck.count).to eq 24

      hand_counts = game_state.player_states.map do |player_state|
        player_state.hand.count
      end

      expect(hand_counts).to all( be 6 )
    end
  end
end
