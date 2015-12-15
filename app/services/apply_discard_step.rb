class ApplyDiscardStep
  def initialize(game_state, step)
    @game_state = game_state
    @step = step
  end

  def call
    card = @step.card

    if !@game_state.table.include?(card)
      raise "Card must be on table to discard"
    end

    @game_state.table.delete(card)
    @game_state.discard_pile.push(card)

    @game_state.attacker = next_attacker

    @game_state
  end

  private

  def next_attacker
    if @game_state.attacker == @step.player
      find_next_attacker
    else
      @game_state.attacker
    end
  end

  def find_next_attacker
    current_attacker_state = @game_state.player_state_for_player(@game_state.attacker)
    current_attacker_index = @game_state.player_states.index(current_attacker_state)

    next_attacker_index = current_attacker_index + 1
    @game_state.player_states[next_attacker_index % @game_state.player_states.count].player 
  end
end
