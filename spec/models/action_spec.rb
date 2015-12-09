require 'rails_helper'

RSpec.describe Action, type: :model do
  describe "validation" do
    it "validates GAME, PLAYER, CARD presence" do
      game = Game.new
      player = Player.new
      card = Card.new
      action = Action.create(game: game, player: player, card: card)
      action.valid?

      expect(action).to be_valid
    end

    it "doesn't validate without GAME presence" do
      player = Player.new
      card = Card.new
      action = Action.create(player: player, card: card)
      action.valid?

      expect(action).to_not be_valid
    end

    it "doesn't validate without PLAYER presence" do
      game = Game.new
      card = Card.new
      action = Action.create(game: game, card: card)
      action.valid?

      expect(action).to_not be_valid
    end

    it "doesn't validate without CARD presence" do
      game = Game.new
      player = Player.new
      action = Action.create(game: game, player: player)
      action.valid?

      expect(action).to_not be_valid
    end
  end
end
