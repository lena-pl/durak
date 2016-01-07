class FollowsRules
  def initialize(step, game_state)
    @step = step
    @game_state = game_state
  end

  def call
    rules_pass?
  end

  private

  def rules_pass?
    if defending?
      good_defend_rank? && good_defend_suit?
    elsif attacking?
      good_attack_rank? && may_be_defended?
    else
      true
    end
  end

  def defending?
    @step.defend?
  end

  def good_defend_rank?
    attacking_card = @step.in_response_to_step.card
    defending_card = @step.card

    if attacking_card.suit != @game_state.trump_card.suit
      (defending_card.rank > attacking_card.rank) || (defending_card.suit == @game_state.trump_card.suit)
    else
      defending_card.rank > attacking_card.rank
    end
  end

  def good_defend_suit?
    attacking_card = @step.in_response_to_step.card
    defending_card = @step.card

    defending_card.suit == attacking_card.suit || defending_card.suit == @game_state.trump_card.suit
  end

  def attacking?
    @step.attack?
  end

  def good_attack_rank?
    attacking_card = @step.card
    @game_state.table.cards.pop

    if !@game_state.table.cards.empty?
      ranks_on_table = @game_state.table.cards.map(&:rank)
      ranks_on_table.include? attacking_card.rank
    else
      true
    end
  end

  def may_be_defended?
    @game_state.player_state_for_player(@game_state.defender).hand.count >= 1
  end
end
