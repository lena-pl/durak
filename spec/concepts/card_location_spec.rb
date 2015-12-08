require 'rails_helper'

RSpec.describe CardLocation do
  context "when a location is initialised in default order" do
    subject { CardLocation.new }

    it "creates an empty location" do
      expect(subject.all.length).to eq 0
    end

    describe "#add" do
      it "adds a card to the location" do
        card = Card.first
        subject.add(card)
        expect(subject.include?(card)).to be_truthy
      end
    end

    describe "#all" do
      it "returns all the cards at the location" do
        card = Card.first
        subject.add(card)
        expect(subject.all).to eq [card]
      end
    end

    describe "#move_to" do
      let(:card) { Card.first }
      let(:deck) { CardLocation.with_cards(Card.all) }

      it "moves a card from the deck to the table" do
        deck.move_to(subject, card)

        expect(subject.include?(card)).to be_truthy
      end
    end
  end

  context "when a location is initialised with cards" do
    let(:cards) { Card.all }
    subject { CardLocation.with_cards(cards) }

    describe "#with_cards" do
      it "returns a full deck" do
        expect(subject.all.length).to eq cards.length
      end
    end
  end

  context "when a location is initialised with an arranger" do
    let(:arranger) { double("Arrangement") }
    subject { CardLocation.new(arranger) }

    describe "#all" do
      it "returns the result of the arrangement" do
        allow(arranger).to receive(:arrange).and_return('test')

        expect(subject.all).to eq 'test'
      end
    end
  end
end
