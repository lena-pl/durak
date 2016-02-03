class TryToApplyStep
  attr_reader :errors

  def initialize(player:, step_kind:, card: nil, in_response_to_step: nil)
    @game = player.game
    @player = player
    @step_kind = step_kind
    @card = card
    @in_response_to_step = in_response_to_step
    @errors = []
  end

  def call
    Step.transaction do
      step = @player.steps.create!(kind: @step_kind, card: @card, in_response_to_step: @in_response_to_step)

      game_state = BuildGameState.new(@game).call

      check_rules_service = CheckRules.new(step, game_state, @game)

      if check_rules_service.call
        CompleteTurn.new(step, game_state).call
      else
        @errors = check_rules_service.errors
        if step.discard? || step.pick_up_from_table? || step.deal?
          @errors = []
        end

        raise ActiveRecord::Rollback
      end
    end
  end
end
