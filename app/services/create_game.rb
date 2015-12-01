class CreateGame
  def initialize
  end

  def call
    game = Game.create!
    2.times { Player.create!(game: game) }

    game
  end
end
