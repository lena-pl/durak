class GameState
  attr_reader :card_locations
  attr_accessor :trump_card, :attacker

  def initialize(trump_card, card_locations, attacker)
    @trump_card = trump_card
    @card_locations = card_locations
    @attacker = attacker
  end

  def self.base_state
    card_locations = CardLocations.new(deck: Card.all)
    GameState.new(nil, card_locations, nil)
  end

end
