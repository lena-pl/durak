class ApplyPickUpFromTableStep
  def initialize(game_state, step)
    @game_state = game_state
    @step = step
  end

  def call
    card = @step.card

    if !@game_state.table.include?(card)
      raise "Card must be on table before it is picked up"
    end

    player_state = @game_state.player_state_for_player(@step.player)

    @game_state.table.delete(card)
    player_state.hand.push(card)

    @game_state
  end
end
