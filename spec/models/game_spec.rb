require 'rails_helper'

RSpec.describe Game, type: :model do
  fixtures :cards

  describe "validation" do
    it "validates TRUMP_CARD presence" do
      card = cards(:hearts_6)
      game = Game.create(:trump_card => card)
      game.valid?

      expect(game).to be_valid
    end
  end
end
