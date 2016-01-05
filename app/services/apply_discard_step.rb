class ApplyDiscardStep
  def initialize(game_state, step)
    @game_state = game_state
    @step = step
  end

  def call
    if @game_state.attacker != @step.player
      raise "Only the attacker can discard cards from the table"
    end

    if @game_state.table.empty?
      raise "Must be at least one card on the table to discard"
    end

    @game_state.discard_pile.push(*@game_state.table.cards)
    @game_state.table.clear

    @game_state.attacker = find_next_attacker

    @game_state
  end

  private

  def find_next_attacker
    current_attacker_state = @game_state.player_state_for_player(@game_state.attacker)
    current_attacker_index = @game_state.player_states.index(current_attacker_state)

    next_attacker_index = current_attacker_index + 1
    @game_state.player_states[next_attacker_index % @game_state.player_states.count].player
  end
end
