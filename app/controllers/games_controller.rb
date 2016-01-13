class GamesController < ApplicationController
  def new
    @game = Game.new
  end

  def create
    @game = CreateGame.new.call
    @current_player = session[:current_player] = @game.players.first

    redirect_to controller: 'games', action: 'show', id: @game.id, token: @game.players.first.token
  end

  def show
    @game = Game.find(params[:id])
    @game_state = BuildGameState.new(@game).call
    @current_player = current_player

    if @game.players.first.connected && @game.players.second.connected
      render :show, layout: !request.xhr?
    else
      render :invite_friend
    end
  end

  def join
    @game = Game.find(params[:id])
    @game.players.second.update_attributes!(connected: true)
    @current_player = session[:current_player] = @game.players.second

    redirect_to controller: 'games', action: 'show', id: @game.id, token: @game.players.second.token
  end

  private

  def current_player
    if params[:token]
      session[:current_player] = @game.players.where('token = ?', params[:token]).first
    end
    session[:current_player]
  end
end
