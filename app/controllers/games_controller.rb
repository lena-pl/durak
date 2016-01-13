class GamesController < ApplicationController
  def new
    @game = Game.new
  end

  def create
    @game = CreateGame.new.call
    @current_player = session[:current_player] = @game.players.first

    redirect_to controller: 'games', action: 'show', id: @game.id, player_id: @game.players.first.id
  end

  def show
    @game = Game.find(params[:id])
    @game_state = BuildGameState.new(@game).call
    @current_player = current_player

    if @game.players.first.connected && @game.players.second.connected
      render :show
    else
      render :invite_friend
    end
  end

  def join
    @game = Game.find(params[:id])
    @game.players.second.update_attributes(connected: true)
    @current_player = session[:current_player] = @game.players.second

    redirect_to controller: 'games', action: 'show', id: @game.id, player_id: @game.players.second.id
  end

  def last_step_id
    @game = Game.find(params[:id])
    render text: @game.steps.last.id
  end

  private

  def current_player
    if params[:player_id]
      session[:current_player] = @game.players.find(params[:player_id])
    end
    session[:current_player]
  end
end
