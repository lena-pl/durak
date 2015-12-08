require 'rails_helper'

RSpec.describe DefaultArrangement do
  let(:cards) { Card.all }
  let(:card_group) {[cards[0], cards[1]]}
  subject { DefaultArrangement.new }

  describe "#arrange" do
    it "returns correctly arranged group of cards" do
      expect(subject.arrange(card_group)).to eq card_group
    end
  end
end
