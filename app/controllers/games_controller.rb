class GamesController < ApplicationController
  def new
    @game = Game.new
  end

  def create
    # TODO dynamic session var name
    @game = CreateGame.new.call
    @current_player = @game.players.first

    session["game_#{@game.id}_token".to_sym] = @current_player.token

    redirect_to @game
  end

  def show
    @game = Game.find(params[:id])
    @game_state = BuildGameState.new(@game).call
    @current_player = @game.players.find_by!(token: session["game_#{@game.id}_token".to_sym])

    if @game.players.first.connected && @game.players.second.connected
      render :show, layout: !request.xhr?
    else
      render :invite_friend
    end
  end

  def join
    @game = Game.find(params[:id])

    connect = ConnectPlayer.new(@game, session).call

    if connect == :ok
      redirect_to @game
    elsif connect == :full
      render :game_full
    end
  end
end
