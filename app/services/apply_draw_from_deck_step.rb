class ApplyDrawFromDeckStep
  def initialize(game_state, step)
    @game_state = game_state
    @step = step
  end

  def call
    card = @step.card

    if !@game_state.deck.include?(card)
      raise BuildGameState::ApplyStepError, "Card must be in deck to be drawn"
    end

    player_state = @game_state.player_state_for_player(@step.player)

    @game_state.deck.delete(card)
    player_state.hand.push(card)

    @game_state
  end
end
