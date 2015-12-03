class ApplyDealAction
  def initialize(game_state, action)
    @game_state = game_state
    @action = action
  end

  def call
    if @action.affected_player == @game_state.player(1)
      hand = :player_one_hand
    elsif @action.affected_player == @game_state.player(2)
      hand = :player_two_hand
    end

    card = @action.active_card

    @game_state.card_locations.move(:deck, hand, card)
    @game_state
  end
end
