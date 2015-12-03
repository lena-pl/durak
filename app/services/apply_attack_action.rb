class ApplyAttackAction
  def initialize(game_state, action)
    @game_state = game_state
    @action = action
  end

  def call
    if @action.initiating_player == @game_state.player(1)
      hand = :player_one_hand
    elsif @action.initiating_player == @game_state.player(2)
      hand = :player_two_hand
    end

    card = @action.active_card

    if !@game_state.card_locations.at(hand).include? card
      raise "Card must be in player's hand to attack"
    end

    @game_state.card_locations.move(hand, :table, card)
    @game_state
  end
end
