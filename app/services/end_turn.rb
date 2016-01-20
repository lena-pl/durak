class EndTurn
  attr_reader :errors

  def initialize(player, game)
    @player = player
    @game = game
    @game_state = BuildGameState.new(@game).call
    @errors = []
  end

  def call
    try_to_apply_step_service = TryToApplyStep.new(game: @game, player: @player, step_kind: step_kind)

    try_to_apply_step_service.call
    @errors = try_to_apply_step_service.errors ||= []
  end

  private

  def step_kind
    if @player == @game_state.attacker
      :discard
    else
      :pick_up_from_table
    end
  end
end
