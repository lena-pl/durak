class BuildGameState
  APPLY_ACTION = {
    deal: ApplyDealAction,
    draw_from_deck: ApplyDrawFromDeckAction,
    pick_up_from_table: ApplyPickUpFromTableAction,
    attack: ApplyAttackAction,
    defend: ApplyDefendAction,
    discard: ApplyDiscardAction,
  }

  def initialize(game)
    @game = game
  end

  def call
    actions = @game.actions.order(:id)

    actions.inject(base_state) do |current_game_state, action|
      APPLY_ACTION[action.kind.to_sym].new(current_game_state, action).call
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
