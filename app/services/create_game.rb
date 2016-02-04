class CreateGame
  def initialize(trump_card = SelectRandomTrumpCard.new.call, session:)
    @trump_card = trump_card
    @session = session
  end

  def call
    game = Game.new(trump_card: @trump_card)
    game.players.new(token: @session["player_token"])
    game.players.new
    game.save!

    game_state = BuildGameState.new(game).call
    DealCards.new(game_state).call

    game
  end
end
