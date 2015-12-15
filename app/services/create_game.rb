class CreateGame
  def initialize(trump_card = Card.first)
    @trump_card = trump_card
  end

  def call
    game = Game.new(trump_card: @trump_card)
    2.times { game.players.new }
    game.save!
    game
  end
end
