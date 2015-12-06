class BuildGameState
  def initialize(game)
    @actions = game.actions
    @base_state = GameState.base_state(game)
  end

  def call
    apply_actions
  end

  private

  def apply_actions
    @actions.each do |action|
      action_service(action).new(@base_state, action).call
    end
  end

  def action_service(action)
    if action.kind == "deal"
      ApplyDealAction
    elsif action.kind == "draw_from_deck"
      ApplyDrawFromDeckAction
    elsif action.kind == "pick_up_from_table"
      ApplyPickUpFromTableAction
    elsif action.kind == "attack"
      ApplyAttackAction
    elsif action.kind == "defend"
      ApplyDefendAction
    elsif action.kind == "discard"
      ApplyDiscardAction
    end  
  end
end
