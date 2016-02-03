class GamesController < ApplicationController
  def new
    @game = Game.new

    render :new, layout: !request.xhr?
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
      render :invite_friend, layout: !request.xhr?
    elsif !params.has_key?(:last_id) && @game.players.first.connected && @game.players.second.connected
      render :show, layout: true
    elsif params[:last_id] == @game.steps.last.to_param
      if params[:submitted] == "true"
        params.delete :submitted
        render :show, layout: false
      else
        head :not_modified
      end
    else
      params.delete :submitted
      render :show, layout: false
    end
  end

  def join
    @game = Game.find(params[:id])

    case ConnectPlayer.new(@game, session).call
    when :ok
      redirect_to @game
    when :game_owner
      flash.notice = "You can't join your own game!"
      redirect_to @game
    when :full
      render :game_full
    end
  end
end
