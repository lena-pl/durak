class ApplyAttackAction
  def initialize(game_state, action)
    @game_state = game_state
    @action = action
  end

  def call
    player_state = @game_state.player_state_for_player(@action.player)
    card = @action.card

    if !player_state.hand.include?(card)
      raise "Card must be in player's hand to attack"
    end

    player_state.hand.delete(card)
    @game_state.table.push(card)
    
    @game_state
  end
end
