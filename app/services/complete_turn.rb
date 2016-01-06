class CompleteTurn
  def initialize(step, game_state)
    @step = step
    @game_state = game_state
  end

  def call
    if @step.discard? || @step.pick_up_from_table?
      DrawCards.new(@game_state).call
    end
  end
end
