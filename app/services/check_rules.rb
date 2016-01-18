class CheckRules
  attr_reader :errors

  def initialize(step, game_state, game)
    @step = step
    @game_state = game_state
    @game = game
    @errors = []
  end

  def call
    rules_pass?
  end

  private

  def rules_pass?
    @errors.push("It's not your turn right now!") if !your_move?

    return false unless your_move?

    if defending?
      check_defending_ruleset
    elsif attacking?
      check_attacking_ruleset
    else
      true
    end
  end

  def defending?
    @step.defend?
  end

  def check_defending_ruleset
    @errors.push("You must defend with a card of higher rank or a trump!") if !defending_rank_higher?
    @errors.push("You must defend with a card of the same suit or a trump!") if !same_suit?

    defending_rank_higher? && same_suit?
  end

  def defending_rank_higher?
    attacking_card = @step.in_response_to_step.card
    defending_card = @step.card

    return defending_card.rank > attacking_card.rank if trump_suit_attacker?(attacking_card)

    (defending_card.rank > attacking_card.rank) || trump_suit_defender?(defending_card)
  end

  def same_suit?
    attacking_card = @step.in_response_to_step.card
    defending_card = @step.card

    defending_card.suit == attacking_card.suit || trump_suit_defender?(defending_card)
  end

  def trump_suit_attacker?(attacking_card)
    attacking_card.suit == @game_state.trump_card.suit
  end

  def trump_suit_defender?(defending_card)
    defending_card.suit == @game_state.trump_card.suit
  end

  def attacking?
    @step.attack?
  end

  def check_attacking_ruleset
    @errors.push("You must attack with one of the ranks already on the table!") if !rank_on_table?
    @errors.push("The defender doesn't have enough cards in their hand!") if !defender_has_enough_cards_to_defend?

    rank_on_table? && defender_has_enough_cards_to_defend?
  end

  def rank_on_table?
    attacking_card = @step.card
    cards_on_table_before_step = @game_state.table.cards - [attacking_card]

    # If it's the first attack of the turn, any rank may be played
    return true if cards_on_table_before_step.empty?

    ranks_on_table = cards_on_table_before_step.map(&:rank)
    ranks_on_table.include? attacking_card.rank
  end

  def defender_has_enough_cards_to_defend?
    @game_state.player_state_for_player(@game_state.defender).hand.count >= 1
  end

  def your_move?
    previous_steps = @game.steps.order("id ASC").reject { |step| step == @step }
    last_step = previous_steps.last

    return @step.player == @game_state.attacker if start_of_game?(previous_steps)

    if attacker_drew_from_deck?(last_step)
      @step.player == last_step.player
    else
      @step.player != last_step.player
    end
  end

  def start_of_game?(previous_steps)
    !previous_steps.map(&:kind).include? Step::ATTACK
  end

  def attacker_drew_from_deck?(last_step)
    last_step.draw_from_deck? && last_step.player == @game_state.attacker
  end
end
