class ConnectPlayer
  def initialize(game, session)
    @game = game
    @session = session
  end

  def call
    if @game.players.first.connected && @game.players.second.connected
      :full
    elsif @session.has_key?("game_#{@game.id}_token".to_sym)
      :game_owner
    else
      @game.players.second.update_attributes!(connected: true)
      @current_player = @game.players.second
      @session["game_#{@game.id}_token".to_sym] = @current_player.token
      :ok
    end
  end
end
