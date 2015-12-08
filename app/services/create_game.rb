class CreateGame
  def initialize(trump_card =  Card.first)
    @trump_card = trump_card
  end

  def call
    #TODO TRANSACTION
    game = Game.create!(trump_card: @trump_card)
    2.times { game.players.create! }

    game
  end
end
