class ApplyPickUpFromTableAction
  def initialize(game_state, action)
    @game_state = game_state
    @action = action
  end

  def call
    card = @action.card

    if !@game_state.table.include?(card)
      raise "Card must be on table before it is picked up"
    end

    player_state = @game_state.player_state_for_player(@action.player)

    @game_state.table.delete(card)
    player_state.hand.push(card)

    @game_state
  end
end
