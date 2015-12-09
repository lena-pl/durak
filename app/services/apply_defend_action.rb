class ApplyDefendAction
  def initialize(game_state, action)
    @game_state = game_state
    @action = action
  end

  def call
    defending_with = @action.card
    defending_against = @action.in_response_to_action.card

    if @action.player == @game_state.player(1)
      player_number = 1
    elsif @action.player == @game_state.player(2)
      player_number = 2
    end

    player_hand = @game_state.player_hand(player_number)

    if !player_hand.include?(defending_with)
      raise "Card must be in player's hand to defend with"
    end

    if already_defended_against?(defending_against)
      raise "#{defending_against} has already been defended by another card"
    end

    if !@game_state.table.include?(defending_against)
      raise "Card must be on table to defend against"
    end

    player_hand.move_to(@game_state.table, defending_with)

    @game_state
  end

  private

  def already_defended_against?(card)
    attack_defend_pair = @game_state.table.all.find { |pair| pair[:attacking_card] == card }

    if !attack_defend_pair.nil?
      defending_card = attack_defend_pair[:defending_card]
      if defending_card.nil?
       false
      else
       true
      end
    else
      false
    end
  end
end
