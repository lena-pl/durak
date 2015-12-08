class ApplyDrawFromDeckAction
  def initialize(game_state, action)
    @game_state = game_state
    @action = action
  end

  def call
    card = @action.active_card

    @game_state.deck.delete(card)

    if @action.initiating_player == @game_state.player(1)
      @game_state.player_hand(1).add(card)
    elsif @action.initiating_player == @game_state.player(2)
      @game_state.player_hand(2).add(card)
    end

    @game_state
  end
end
