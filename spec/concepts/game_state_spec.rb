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

  describe "#game_over?" do
    before do
      subject.deck.delete(cards(:hearts_6))
      subject.player_state_for_player(player_one).hand.push(cards(:hearts_6))
      subject.deck.cards.clear
    end

    it "evaluates game over as true" do
      expect(subject.game_over?).to eq true
    end
  end
end
