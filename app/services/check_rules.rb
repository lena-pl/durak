class CheckRules
  attr_reader :errors

  def initialize(step, game_state, game)
    @step = step
    @game_state = game_state
    @game = game
    @errors = []
  end

  def call
    rules_pass
  end

  private

  def rules_pass
    if !player_can_move?
      @errors.push("It's not your turn right now!")
    elsif defending?
      check_defending_ruleset
    elsif attacking?
      check_attacking_ruleset
    end

    @errors.empty?
  end

  def defending?
    @step.defend?
  end

  def check_defending_ruleset
    @errors.push("You must defend with a card of higher rank or a trump!") if !defending_rank_higher?
    @errors.push("You must defend with a card of the same suit or a trump!") if !defending_suit_same_or_better?
  end

  def defending_rank_higher?
    attacking_card = @step.in_response_to_step.card
    defending_card = @step.card

    card_points(defending_card) > card_points(attacking_card)
  end

  def card_points(card)
    if trump_suit_card?(card)
      card.rank + Card::RANK_RANGE.max
    else
      card.rank
    end
  end

  def defending_suit_same_or_better?
    attacking_card = @step.in_response_to_step.card
    defending_card = @step.card

    defending_card.suit == attacking_card.suit || trump_suit_card?(defending_card)
  end

  def trump_suit_card?(card)
    card.suit == @game_state.trump_card.suit
  end

  def attacking?
    @step.attack?
  end

  def check_attacking_ruleset
    @errors.push("You must attack with one of the ranks already on the table!") if !rank_on_table?
    @errors.push("The defender doesn't have enough cards in their hand!") if !defender_has_enough_cards_to_defend?
  end

  def rank_on_table?
    attacking_card = @step.card
    cards_on_table_before_step = @game_state.table.cards - [attacking_card]

    # If it's the first attack of the turn, any rank may be played
    if cards_on_table_before_step.present?
      ranks_on_table = cards_on_table_before_step.map(&:rank)
      ranks_on_table.include?(attacking_card.rank)
    else
      true
    end
  end

  def defender_has_enough_cards_to_defend?
    @game_state.player_state_for_player(@game_state.defender).hand.count >= 1
  end

  def player_can_move?
    previous_steps = @game.steps.ordered.where.not(id: @step)
    last_step = previous_steps.last

    if start_of_game?(previous_steps)
      @step.player == @game_state.attacker
    elsif attacker_drew_from_deck?(last_step)
      @step.player == last_step.player
    else
      @step.player != last_step.player
    end
  end

  def start_of_game?(previous_steps)
    previous_steps.none?(&:attack?)
  end

  def attacker_drew_from_deck?(last_step)
    last_step.draw_from_deck? && last_step.player == @game_state.attacker
  end
end
