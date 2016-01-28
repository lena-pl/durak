class ApplyAttackStep
  def initialize(game_state, step)
    @game_state = game_state
    @step = step
  end

  def call
    player_state = @game_state.player_state_for_player(@step.player)
    card = @step.card

    if !player_state.hand.include?(card)
      raise BuildGameState::ApplyStepError, "Card must be in player's hand to attack"
    end

    player_state.hand.delete(card)
    @game_state.table.push(card)

    @game_state
  end
end
