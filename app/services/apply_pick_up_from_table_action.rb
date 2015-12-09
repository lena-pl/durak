class ApplyPickUpFromTableAction
  def initialize(game_state, action)
    @game_state = game_state
    @action = action
  end

  def call
    card = @action.card

    if !@game_state.table.include?(card)
      raise "Card must be on table before it is picked up"
    end

    if @action.player == @game_state.player(1)
      @game_state.table.move_to(@game_state.player_hand(1), card)
    elsif @action.player == @game_state.player(2)
      @game_state.table.move_to(@game_state.player_hand(2), card)
    end

    @game_state
  end
end
