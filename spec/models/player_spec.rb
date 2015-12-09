require 'rails_helper'

RSpec.describe Player, type: :model do

  describe "validation" do
    it "validates GAME presence" do
      game = Game.new
      player = Player.create(game: game)
      player.valid?

      expect(player).to be_valid
    end

    it "doesn't validate without GAME presence" do
      player = Player.create
      player.valid?

      expect(player).to_not be_valid
    end
  end
end
