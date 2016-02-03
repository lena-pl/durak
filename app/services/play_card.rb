class PlayCard
  attr_reader :errors

  def initialize(player, card)
    @player = player
    @card = card
    @game = player.game
    @game_state = BuildGameState.new(@game).call
    @errors = []
  end

  def call
    service = TryToApplyStep.new(player: @player, step_kind: step_kind, card: @card, in_response_to_step: in_response_to_step(step_kind))

    service.call
    @errors = service.errors || []
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
