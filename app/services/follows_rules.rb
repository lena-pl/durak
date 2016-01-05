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
    else
      true
    end
  end

  def defending?
    @step.kind == "defend"
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
end
