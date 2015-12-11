class ApplyDrawFromDeckAction
  def initialize(game_state, action)
    @game_state = game_state
    @action = action
  end

  def call
    card = @action.card

    if !@game_state.deck.include?(card)
      raise "Card must be in deck to be drawn"
    end

    player_state = @game_state.player_state_for_player(@action.player)

    @game_state.deck.delete(card)
    player_state.hand.push(card)

    @game_state
  end
end
