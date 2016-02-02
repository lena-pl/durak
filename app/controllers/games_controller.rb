class GamesController < ApplicationController
  def new
    @game = Game.new
  end

  def create
    @game = CreateGame.new.call
    @current_player = @game.players.first

    session["game_#{@game.id}_token".to_sym] = @current_player.token

    redirect_to @game
  end

  def show
    @game = Game.find(params[:id])
    @game_state = BuildGameState.new(@game).call
    @current_player = @game.players.find_by!(token: session["game_#{@game.id}_token".to_sym])

    if !@game.players.second.connected
      render :invite_friend
    elsif !params.has_key?(:last_id) && @game.players.first.connected && @game.players.second.connected
      render :show, layout: true
    elsif params[:last_id] == @game.steps.last.id.to_s
      if params[:submitted] == "true"
        params.delete :submitted
        render :show, layout: false
      else
        head :not_modified
      end
    elsif params[:last_id] != @game.steps.last.id.to_s
      params.delete :submitted
      render :show, layout: false
    end
  end

  def join
    @game = Game.find(params[:id])

    connect = ConnectPlayer.new(@game, session).call

    if connect == :ok
      redirect_to @game
    elsif connect == :game_owner
      flash.notice = "You can't join your own game!"
      redirect_to @game
    elsif connect == :full
      render :game_full
    end
  end
end
