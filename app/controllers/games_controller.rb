class GamesController < ApplicationController
  def new
    @game = Game.new
  end

  def create
    game = CreateGame.new.call
    game_state = BuildGameState.new(@game).call
    DealCards.new(game_state).call

    redirect_to game
  end

  def show
   @game = Game.find(params[:id])
   @game_state = BuildGameState.new(@game).call
  end
end
