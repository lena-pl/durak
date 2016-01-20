class TryToApplyStep
  attr_reader :errors

  def initialize(game:, player:, step_kind:, card_id: nil, in_response_to_step: nil)
    @game = game
    @player = player
    @step_kind = step_kind
    @card_id = card_id
    @in_response_to_step = in_response_to_step
    @errors = []
  end

  def call
    Step.transaction do
      step = @player.steps.create!(kind: @step_kind, card_id: @card_id, in_response_to_step: @in_response_to_step)

      game_state = BuildGameState.new(@game).call

      check_rules_service = CheckRules.new(step, game_state, @game)

      if check_rules_service.call
        CompleteTurn.new(step, game_state).call
      else
        @errors = check_rules_service.errors
        raise ActiveRecord::Rollback
      end
    end
  end
end
