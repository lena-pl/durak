class ApplyPickUpFromTableStep
  def initialize(game_state, step)
    @game_state = game_state
    @step = step
  end

  def call
    if @game_state.defender != @step.player
      raise "Only the defender can pick up cards from the table"
    end

    if @game_state.table.empty?
      raise "Must be at least one card on the table to pickup"
    end

    player_state = @game_state.player_state_for_player(@step.player)

    player_state.hand.push(*@game_state.table.cards)
    @game_state.table.clear

    @game_state
  end
end
