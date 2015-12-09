class BuildGameState
  APPLY_ACTION = {
    deal: ApplyDealAction,
    draw_from_deck: ApplyDrawFromDeckAction,
    pickup_from_table: ApplyPickUpFromTableAction,
    attack: ApplyAttackAction,
    defend: ApplyDefendAction,
    discard: ApplyDiscardAction,
  }

  def initialize(game)
    @game = game
  end

  def call
    @game.actions.inject(base_state) do |current_game_state, action|
      APPLY_ACTION[action.kind.to_sym].new(current_game_state, action).call
    end
  end

  private

  def base_state
    GameState.new(trump_card, deck, players, player_hands, table, discard_pile, attacker)
  end

  def trump_card
    @game.trump_card
  end

  def deck
    CardLocation.with_cards(Card.all)
  end

  def players
    @game.players.all
  end

  def player_hands
    players.map { CardLocation.new }
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
