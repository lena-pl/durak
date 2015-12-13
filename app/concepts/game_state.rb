class GameState
  attr_reader :player_states, :table, :deck, :trump_card, :discard_pile
  attr_accessor :attacker

  def initialize(trump_card, deck, player_states, table, discard_pile, attacker)
    @trump_card = trump_card
    @deck = deck
    @player_states = player_states
    @table = table
    @discard_pile = discard_pile
    @attacker = attacker
  end

  def player_state_for_player(player)
    @player_states.find { |player_state| player_state.player == player }
  end
end
