class GameState
  MAX_PLAYERS = 2

  attr_reader :card_locations, :players
  attr_accessor :trump_card, :attacker

  def initialize(trump_card, card_locations, attacker, players)
    @trump_card = trump_card
    @card_locations = card_locations
    @attacker = attacker
    @players = players
  end

  def self.base_state(game)
    trump_card = game.trump_card
    card_locations = CardLocations.new(deck: Card.all)
    attacker = nil
    players = game.players.all
    GameState.new(trump_card, card_locations, attacker, players)
  end

  def player(player_number)
    if !player_number.between?(1, MAX_PLAYERS)
      raise "Invalid player_number. Must be between 1 and #{MAX_PLAYERS}"
    end

    @players[player_number - 1]
  end
end
