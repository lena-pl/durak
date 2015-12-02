require 'rails_helper'

RSpec.describe GameState do
  let(:trump_card) { Card.create!(:rank => 6, :suit => :hearts) }
  let(:game) { Game.create!(:trump_card => trump_card) }
  let!(:player_one) { Player.create!(:game => game) }
  let!(:player_two) { Player.create!(:game => game) }
  subject { GameState.base_state(game) }

  describe ".base_state" do
    it "returns GameState with trump_card from game" do
      expect(subject.trump_card).to eq game.trump_card
    end

    it "returns GameState with complete deck at :deck location" do
      expect(subject.card_locations.at(:deck)).to eq Card.all
    end

    it "returns GameState with nil attacker" do
      expect(subject.attacker).to be_nil
    end

    it "returns GameState with the players in the game" do
      expect(subject.players).to eq [player_one, player_two]
    end
  end

  describe "#player" do
    it "returns the first player" do
      expect(subject.player(1)).to eq player_one
    end

    it "returns the second player" do
      expect(subject.player(2)).to eq player_two
    end

    it "raises an error if player number less than 1" do
      expect { subject.player(0) }.to raise_error("Invalid player_number. Must be between 1 and #{GameState::MAX_PLAYERS}")
    end

    it "raises an error if player number greater than MAX_PLAYERS" do
      expect{ subject.player(GameState::MAX_PLAYERS + 1) }.to raise_error("Invalid player_number. Must be between 1 and #{GameState::MAX_PLAYERS}")
    end
  end
end
