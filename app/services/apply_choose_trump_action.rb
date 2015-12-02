class ApplyChooseTrumpAction
  def initialize(game_state, action)
    @game_state = game_state
    @action = action
  end

  def call
    @game_state.trump_card = @action.active_card
    @game_state
  end
end
