class ApplyDiscardAction
  def initialize(game_state, action)
    @game_state = game_state
    @action = action
  end

  def call
    card = @action.active_card

    if !@game_state.card_locations.at(:table).include? card
      raise "Card must be on table to discard"
    end

    @game_state.card_locations.move(:table, :discard_pile, card)
    @game_state
  end
end
