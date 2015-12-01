class GamesController < ApplicationController
  def new
    @game = Game.new
  end

  def create
    game = CreateGame.new.call

    redirect_to game
  end
end
