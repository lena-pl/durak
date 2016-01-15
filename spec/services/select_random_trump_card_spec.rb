require 'rails_helper'

RSpec.describe SelectRandomTrumpCard do
  describe "#call" do
    subject(:card) { SelectRandomTrumpCard.new.call }

    it "selects a card within available rank range" do
      expect(card.rank).to be_between 6,14
    end

    it "selects a card from one of available suits" do
      expect(["hearts", "diamonds", "spades", "clubs"]).to include(card.suit)
    end

    it "generates 100 random cards of correct rank and suit" do
      100.times do
        card = SelectRandomTrumpCard.new.call
        expect(card.rank).to be_between 6,14
        expect(["hearts", "diamonds", "spades", "clubs"]).to include(card.suit)
      end
    end
  end
end
