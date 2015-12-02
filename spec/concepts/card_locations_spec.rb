require 'rails_helper'

RSpec.describe CardLocations do
  def card(rank, suit)
    Card.find_by!(rank: rank, suit: Card.suits[suit])
  end
  
  def initialize_deck
    Card.suits.each do |suit, enumeration|
      6.upto(14) do |rank|
        Card.create!(rank: rank, suit: suit)
      end
    end
  end

  before(:all) do 
    initialize_deck
  end

  context "when cards have been initialized in one location" do
    let(:cards) {[
      card(10, "hearts"),
      card(11, "diamonds"),
      card(14, "clubs"),
    ]} 
    let(:card_locations) { CardLocations.new(deck: cards) }
    

    describe "#at" do
      it "returns the cards at that given location" do 
        expect(card_locations.at(:deck)).to eq cards
      end
    end

    describe "#move" do
      context "when a card is moved from one location to a new location" do
        before do
          card_locations.move(:deck, :hand, cards[0]) 
        end
        
        it "moves the card to that new location" do
          expect(card_locations.at(:hand)).to eq [cards[0]]
        end

        it "moves the card out of its old location" do
          expect(card_locations.at(:deck)).to eq [cards[1], cards[2]]
        end
      end
    end
  end

  context "when cards have been initialized in two locations" do
    let(:deck) {[
      card(10, "hearts"),
      card(14, "spades"),
    ]}
    let(:hand) {[
      card(6, "hearts"),
      card(8, "spades"),
    ]}

    let(:card_locations) { CardLocations.new(deck: deck, hand: hand) }

    describe "#at" do
      it "returns the correct cards in the first location" do
        expect(card_locations.at(:deck)).to eq deck
      end

      it "returns the correct cards in the second location" do
        expect(card_locations.at(:hand)).to eq hand
      end
    end

    describe "#move" do
      context "when a card is moved between two existing locations" do
        before do
          card_locations.move(:deck, :hand, deck[0])
        end

        it "moves the card to its new location" do
          expect(card_locations.at(:hand)).to eq [hand[0], hand[1], deck[0]]
        end

        it "moves the card out of its old location" do
          expect(card_locations.at(:deck)).to eq [deck[1]]
        end
      end
    end

  end
end
