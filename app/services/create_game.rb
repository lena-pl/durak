class CreateGame
  def initialize(trump_card = SelectRandomTrumpCard.new.call)
    @trump_card = trump_card
  end

  def call
    game = Game.new(trump_card: @trump_card)
    game.players.new(connected: true)
    game.players.new
    game.save!

    game_state = BuildGameState.new(game).call
    DealCards.new(game_state).call

    game
  end
end
