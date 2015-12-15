class BuildGameState
  APPLY_STEP = {
    deal: ApplyDealStep,
    draw_from_deck: ApplyDrawFromDeckStep,
    pick_up_from_table: ApplyPickUpFromTableStep,
    attack: ApplyAttackStep,
    defend: ApplyDefendStep,
    discard: ApplyDiscardStep,
  }

  def initialize(game)
    @game = game
  end

  def call
    steps = @game.steps.order(:id)

    steps.inject(base_state) do |current_game_state, step|
      APPLY_STEP[step.kind.to_sym].new(current_game_state, step).call
    end
  end

  private

  def base_state
    GameState.new(trump_card, deck, player_states, table, discard_pile, attacker)
  end

  def trump_card
    @game.trump_card
  end

  def deck
    CardLocation.with_cards(Card.all)
  end

  def player_states
    @game.players.map { |player| PlayerState.new(player: player, hand: CardLocation.new) }
  end

  def table
    CardLocation.new(TableArrangement.new)
  end

  def discard_pile
    CardLocation.new
  end

  def attacker
    nil
  end
end
