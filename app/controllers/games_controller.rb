class GamesController < ApplicationController
  def new
    @game = Game.new
  end

  def create
    game = CreateGame.new.call
    DealCards.new(game).call

    redirect_to game
  end

  def show
   game = Game.find(params[:id])
   @game_state = BuildGameState.new(game).call
  end
end
