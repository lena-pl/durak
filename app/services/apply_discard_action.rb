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

    player_state = @game_state.player_state_for_player(@action.player)

    @game_state.table.delete(card)
    player_state.hand.push(card)

    @game_state.attacker = find_new_attacker(player_state)

    @game_state
  end

  private

  def find_new_attacker(player_state)
    player_position = @game_state.player_states.index(player_state)
    player_position = player_position % @game_state.player_states.count

    @game_state.player_states[player_position]
  end
end
