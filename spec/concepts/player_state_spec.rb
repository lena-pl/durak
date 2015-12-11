require 'rails_helper'

RSpec.describe PlayerState do
  fixtures :cards

  let(:player_hand) { CardLocation.new }
  let(:player) { instance_double(Player) }
  subject(:player_state) { PlayerState.new(player: player, hand: player_hand) }

  context "when there are only spades and the lowest is 6" do
    before do
      player_hand.push(cards(:spades_6), cards(:spades_7), cards(:spades_9))
    end

    describe "#lowest_card_with_suit" do
      it "returns the 6 of spades" do
        expect(subject.lowest_card_with_suit("spades")).to eq cards(:spades_6)
      end

      it "returns nil when finding lowest card in diamonds" do
        expect(subject.lowest_card_with_suit("diamonds")).to be_nil
      end
    end
  end

  context "when there is a mix of suits of the same rank" do
    before do
      player_hand.push(cards(:spades_7), cards(:clubs_7), cards(:diamonds_7), cards(:hearts_7))
    end

    describe "#lowest_card_with_suit" do
      it "returns the lowest card in hearts" do
        expect(subject.lowest_card_with_suit("hearts")).to eq cards(:hearts_7)
      end

      it "returns the lowest card in diamonds" do
        expect(subject.lowest_card_with_suit("diamonds")).to eq cards(:diamonds_7)
      end
    end
  end

  context "when there is a mix of suits of different ranks" do
    before do
      player_hand.push(cards(:spades_13), cards(:spades_8), cards(:clubs_10), cards(:diamonds_6), cards(:hearts_7), cards(:clubs_9))
    end

    describe "#lowest_card_with_suit" do
      it "returns the lowest card in clubs" do
        expect(subject.lowest_card_with_suit("clubs")).to eq cards(:clubs_9)
      end

      it "returns the lowest card in spades" do
        expect(subject.lowest_card_with_suit("spades")).to eq cards(:spades_8)
      end

      it "returns the lowest card in diamonds" do
        expect(subject.lowest_card_with_suit("diamonds")).to eq cards(:diamonds_6)
      end
    end
  end

  context "when the player has no cards" do
    describe "#lowest_card_with_suit" do
      it "returns nil" do
        expect(subject.lowest_card_with_suit("clubs")).to be_nil
      end
    end
  end
end
