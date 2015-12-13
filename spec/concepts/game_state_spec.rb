require 'rails_helper'

RSpec.describe GameState do
  fixtures :cards

  let(:game) { CreateGame.new(cards(:hearts_7)).call }
  let!(:player_one) { game.players.first }
  let!(:player_two) { game.players.second }

  subject { BuildGameState.new(game).call }

  describe "#player_state_for_player" do
    it "returns player one state for player one" do
      expect(subject.player_state_for_player(player_one)).to eq subject.player_states.first
    end

    it "returns player two state for player two" do
      expect(subject.player_state_for_player(player_two)).to eq subject.player_states.second
    end
  end
end
