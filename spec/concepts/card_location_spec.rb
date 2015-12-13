require 'rails_helper'

RSpec.describe CardLocation do
  fixtures :cards

  let(:card) { cards(:hearts_12) }
  subject { CardLocation.new }

  context "when a new location is created with no cards" do
    describe "#arranged" do
      it "is empty" do
        expect(subject.arranged).to be_empty
      end
    end
  end

  context "when a new location is created with some cards" do
    let(:cards_at_location) {[
      cards(:hearts_6),
      cards(:hearts_7),
      cards(:spades_8)
    ]}
    let(:card_location) { CardLocation.with_cards(cards_at_location) }
    subject { card_location }

    it "is not empty" do
      expect(subject).to_not be_empty
    end

    it "includes the cards that it was created with" do
      expect(subject).to include(*cards_at_location)
    end

    it "does not include cards that it wasn't created with" do
      expect(subject).to_not include(cards(:diamonds_7))
    end

    it "has correct number of cards" do
        expect(subject.count).to eq cards_at_location.count
    end

    describe "#arranged" do
      it "is not empty" do
        expect(subject.arranged).to_not be_empty
      end
    end
  end

  context "when a location is created with an arranger"do
    let(:arranger) { double }
    subject { CardLocation.new(arranger) }

    it "uses that arranger to arrange the cards" do
      expect(arranger).to receive(:arrange)
      subject.arranged
    end
  end
end
