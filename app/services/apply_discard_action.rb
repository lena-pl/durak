class ApplyDiscardAction
  def initialize(game_state, action)
    @game_state = game_state
    @action = action
  end

  def call
    card = @action.active_card

    if !@game_state.table.include?(card)
      raise "Card must be on table to discard"
    end

    @game_state.table.move_to(@game_state.discard_pile, card)

    @game_state
  end
end
