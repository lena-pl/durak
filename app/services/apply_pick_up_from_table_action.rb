class ApplyPickUpFromTableAction
  def initialize(game_state, action)
    @game_state = game_state
    @action = action
  end

  def call
    card = @action.active_card

    if !@game_state.card_locations.at(:table).include?(card)
      raise "Card must be on table before it is picked up"
    end

    if @action.initiating_player == @game_state.player(1)
      hand = :player_one_hand
    elsif @action.initiating_player == @game_state.player(2)
      hand = :player_two_hand
    end
    
    @game_state.card_locations.move(:table, hand, card) 
    @game_state
  end
end
