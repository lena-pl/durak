class ConnectPlayer
  def initialize(game, session)
    @game = game
    @session = session
  end

  def call
    @session["player_token"] ||= SecureRandom.hex

    if @game.players.first.token && @game.players.second.token
      :full
    elsif @session["player_token"] == @game.players.first.token
      :game_owner
    else
      @game.players.second.update_attributes!(token: @session["player_token"])
      :ok
    end
  end
end
