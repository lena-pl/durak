class FollowsRules
  attr_reader :errors

  def initialize(step, game_state)
    @step = step
    @game_state = game_state
    @errors = []
  end

  def call
    rules_pass?
  end

  private

  def rules_pass?
    if defending?
      @errors.push("You must defend with a card of higher rank or a trump!") if !good_defend_rank?
      @errors.push("You must defend with a card of the same suit or a trump!") if !good_defend_suit?
      good_defend_rank? && good_defend_suit?
    elsif attacking?
      @errors.push("You must attack with one of the ranks already on the table!") if !good_attack_rank?
      @errors.push("The defender doesn't have enough cards in their hand!") if !may_be_defended?
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
    cards_on_table_before_step = @game_state.table.cards.reject { |card| card == attacking_card }

    unless cards_on_table_before_step.empty?
      ranks_on_table = cards_on_table_before_step.map(&:rank)
      ranks_on_table.include? attacking_card.rank
    else
      true
    end
  end

  def may_be_defended?
    @game_state.player_state_for_player(@game_state.defender).hand.count >= 1
  end
end
