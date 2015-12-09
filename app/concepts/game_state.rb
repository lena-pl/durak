class GameState
  MAX_PLAYERS = 2

  attr_reader :players, :table, :deck, :trump_card, :discard_pile
  attr_accessor :attacker

  def initialize(trump_card, deck, players, player_hands, table, discard_pile, attacker)
    @trump_card = trump_card
    @deck = deck
    @players = players
    @player_hands = player_hands
    @table = table
    @discard_pile = discard_pile
    @attacker = attacker
  end

  def player(player_number)
    check_valid_player_number(player_number)

    @players[player_number - 1]
  end

  def player_hand(player_number)
    check_valid_player_number(player_number)

    @player_hands[player_number - 1]
  end

  private

  def check_valid_player_number(player_number)
    if !player_number.between?(1, MAX_PLAYERS)
      raise "Invalid player_number. Must be between 1 and #{MAX_PLAYERS}"
    end
  end
end
