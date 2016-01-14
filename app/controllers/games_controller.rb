class GamesController < ApplicationController
  def new
    @game = Game.new
  end

  def create
    @game = CreateGame.new.call
    @current_player = @game.players.first
    session[:current_player_token] = @current_player.token

    redirect_to controller: 'games', action: 'show', id: @game.id
  end

  def show
    @game = Game.find(params[:id])
    @game_state = BuildGameState.new(@game).call
    @current_player = @game.players.find_by!(token: session[:current_player_token])

    if @game.players.first.connected && @game.players.second.connected
      render :show, layout: !request.xhr?
    else
      render :invite_friend
    end
  end

  def join
    @game = Game.find(params[:id])
    @game.players.second.update_attributes!(connected: true)
    @current_player = @game.players.second
    session[:current_player_token] = @current_player.token

    redirect_to controller: 'games', action: 'show', id: @game.id
  end
end
