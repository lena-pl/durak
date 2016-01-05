class GameState
  STANDARD_HAND_SIZE = 6

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

  def tie?
    final_phase? && hands_with_cards.empty?
  end

  def over?
    durak_found? || tie?
  end

  def current_player
    if @table.empty?
      attacker
    else
      last_attack_defend_pair = @table.arranged.last

      if last_attack_defend_pair[:defending_card].nil?
        defender
      else
        attacker
      end
    end
  end

  def defender
    @player_states.find { |player_state| player_state.player != attacker }.player
  end

  def durak
    durak_found? ? hands_with_cards.first.player : nil
  end

  def winner
    if durak_found?
      @player_states.find { |player_state| player_state.player != durak }.player
    else
      nil
    end
  end

  private

  def durak_found?
    final_phase? && hands_with_cards.count == 1
  end

  def final_phase?
    @deck.empty? && @table.empty?
  end

  def hands_with_cards
    @player_states.select { |player_state| !player_state.hand.empty? }
  end
end
