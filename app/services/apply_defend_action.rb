class ApplyDefendAction
  def initialize(game_state, action)
    @game_state = game_state
    @action = action
  end

  def call
    active_card = @action.active_card
    passive_card = @action.passive_card

    if @action.player == @game_state.player(1)
      player_number = 1
    elsif @action.player == @game_state.player(2)
      player_number = 2
    end

    hand = @game_state.player_hand(player_number)

    if !hand.include?(active_card)
      raise "Card must be in player's hand to defend with"
    end

    if !@game_state.table.include?(passive_card)
      raise "Card must be on table to defend against"
    end

    hand.move_to(@game_state.table, active_card)

    @game_state
  end
end
