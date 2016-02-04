require 'rails_helper'

RSpec.describe TableArrangement do
  let(:cards) { Card.all }
  let(:card_group) {[cards[0], cards[1]]}
  subject { TableArrangement.new }

  describe "#arrange" do
    it "returns correctly arranged group of cards" do
      pair = TableArrangement::Pair.new(card_group[0], card_group[1])

      expect(subject.arrange(card_group).first).to eql pair
    end
  end
end
