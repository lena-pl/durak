require 'rails_helper'

RSpec.describe TableArrangement do
  let(:cards) { Card.all }
  let(:card_group) {[cards[0], cards[1]]}
  subject { TableArrangement.new }

  describe "#arrange" do
    it "returns correctly arranged group of cards" do
      expect(subject.arrange(card_group)).to eq [{ :attacking_card => card_group[0], :defending_card => card_group[1] }]
    end
  end
end
