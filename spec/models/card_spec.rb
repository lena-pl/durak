require 'rails_helper'

RSpec.describe Card, type: :model do
  fixtures :cards

  describe "validation" do
    it "validates SUIT and RANK presence" do
      card = cards(:hearts_6)
      card.valid?

      expect(card).to be_valid
    end

    it "validates RANK uniqueness within a SUIT" do
      card = Card.create(:rank => 10, :suit => "hearts")
      card.valid?

      expect(card).to_not be_valid
    end

    it "validates RANK numericality greater_than 5" do
      card = Card.create(:rank => 5, :suit => "hearts")
      card.valid?

      expect(card).to_not be_valid
    end

    it "validates RANK numericality less_than 15" do
      card = Card.create(:rank => 15, :suit => "hearts")
      card.valid?

      expect(card).to_not be_valid
    end
  end
end
