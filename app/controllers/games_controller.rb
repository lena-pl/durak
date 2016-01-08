class GamesController < ApplicationController
  def new
    @game = Game.new
  end

  def create
    @game = CreateGame.new.call

    render :invite_friend
  end

  def show
   @game = Game.find(params[:id])
   @game_state = BuildGameState.new(@game).call
  end

  def join
    @game = Game.find(params[:id])
    @game.players.second.update_attributes(connected: true)

    redirect_to @game
  end
end
