class ApplyDiscardAction
  def initialize(game_state, action)
    @game_state = game_state
    @action = action
  end

  def call
    card = @action.card

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
    if @game_state.attacker == @action.player
      find_next_attacker
    else
      @game_state.attacker
    end
  end

  def find_next_attacker
    player_state = @game_state.player_state_for_player(@action.player)

    player_position = @game_state.player_states.index(player_state)
    player_position = player_position % @game_state.player_states.count

    @game_state.player_states[player_position].player
  end
end
