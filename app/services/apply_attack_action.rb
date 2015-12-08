class ApplyAttackAction
  def initialize(game_state, action)
    @game_state = game_state
    @action = action
  end

  def call
    card = @action.active_card

    if @action.initiating_player == @game_state.player(1)
      player_number = 1
    elsif @action.initiating_player == @game_state.player(2)
      player_number = 2
    end

    if !@game_state.player_hand(player_number).include?(card)
      raise "Card must be in player's hand to attack"
    end

    @game_state.player_hand(player_number).move_to(@game_state.table, card)

    @game_state
  end
end
