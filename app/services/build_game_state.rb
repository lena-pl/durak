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
    @game.actions.inject(GameState.base_state(@game)) do |current_game_state, action|
      APPLY_ACTION[action.kind.to_sym].new(current_game_state, action).call
    end
  end
end
