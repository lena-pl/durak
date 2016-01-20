class PlayCard
  attr_reader :errors

  def initialize(player, card_id, game)
    @player = player
    @card_id = card_id
    @game = game
    @game_state = BuildGameState.new(@game).call
    @errors = []
  end

  def call
    try_to_apply_step_service = TryToApplyStep.new(game: @game, player: @player, step_kind: step_kind, card_id: @card_id, in_response_to_step: in_response_to_step(step_kind))

    try_to_apply_step_service.call
    @errors = try_to_apply_step_service.errors ||= []
  end

  private

  def step_kind
    if @player == @game_state.attacker
      :attack
    else
      :defend
    end
  end

  def in_response_to_step(step_kind)
    if step_kind == :defend
      @game.steps.last
    end
  end
end
