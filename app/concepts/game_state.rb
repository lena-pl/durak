class GameState
  attr_reader :trump_suit, :cards_in_deck, :player_one_hand, :player_two_hand, :discard_pile, :cards_on_table, :attacker

  def initialize(trump_suit, cards_in_deck, player_one_hand, player_two_hand, discard_pile, cards_on_table, attacker)
    @trump_suit = trump_suit
    @cards_in_deck = cards_in_deck
    @player_one_hand = player_one_hand
    @player_two_hand = player_two_hand
    @discard_pile = discard_pile
    @cards_on_table = cards_on_table
    @attacker = attacker
  end
end
