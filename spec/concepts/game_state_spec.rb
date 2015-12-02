require 'rails_helper'

RSpec.describe GameState do
  describe ".base_state" do
    subject { GameState.base_state }

    it "returns GameState with nil trump_card" do
      expect(subject.trump_card).to be_nil
    end

    it "returns GameState with complete deck at :deck location" do
      expect(subject.card_locations.at(:deck)).to eq Card.all
    end

    it "returns GameState with nil attacker" do
      expect(subject.attacker).to be_nil
    end
  end
end
