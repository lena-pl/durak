class StepsController < ApplicationController

  def create
    game = Game.find(params[:game_id])
    player = game.players.find(params[:player_id])

    Step.transaction do
      step = player.steps.create!(step_params)

      game_state = BuildGameState.new(game).call

      follow_rules_service = FollowsRules.new(step, game_state, game)

      if follow_rules_service.call
        CompleteTurn.new(step, game_state).call
      else
        flash.alert = follow_rules_service.errors
        raise ActiveRecord::Rollback
      end
    end

    render nothing: true
  end

  private

  def step_params
    params.require(:step).permit(:kind, :card_id, :in_response_to_step_id)
  end
end
