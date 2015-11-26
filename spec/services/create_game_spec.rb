require 'rails_helper'

RSpec.describe CreateGame do
  describe "#call" do
    before do
      @game = CreateGame.new.call
    end

    it "creates a game" do
      expect(@game).to eq(Game.last)
    end

    it "creates 2 players" do
      expect(Player.find(1).game).to eq(@game)
      expect(Player.find(2).game).to eq(@game)
    end
  end
end
