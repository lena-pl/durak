class EndTurn
  attr_reader :errors

  def initialize(player)
    @player = player
    @game = player.game
    @game_state = BuildGameState.new(@game).call
    @errors = []
  end

  def call
    service = TryToApplyStep.new(player: @player, step_kind: step_kind)
    service.call

    @errors = service.errors || []
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
