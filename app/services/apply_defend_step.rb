class ApplyDefendStep
  def initialize(game_state, step)
    @game_state = game_state
    @step = step
  end

  def call
    defending_with = @step.card
    defending_against = @step.in_response_to_step.card

    player_state = @game_state.player_state_for_player(@step.player)

    if !player_state.hand.include?(defending_with)
      raise "Card must be in player's hand to defend with"
    end

    if already_defended_against?(defending_against)
      raise "#{defending_against} has already been defended by another card"
    end

    if !player_state.hand.include?(defending_against)
      if !@game_state.table.include?(defending_against)
        raise "Card must be on table to defend against"
      end
    end

    player_state.hand.delete(defending_with)
    @game_state.table.push(defending_with)

    @game_state
  end

  private

  def already_defended_against?(card)
    attack_defend_pair = @game_state.table.arranged.find { |pair| pair[:attacking_card] == card }

    if attack_defend_pair.nil?
      false
    else
      defending_card = attack_defend_pair[:defending_card]
      !defending_card.nil?
    end
  end
end
