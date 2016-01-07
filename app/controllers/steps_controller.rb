class StepsController < ApplicationController
  def create
    game = Game.find(params[:game_id])
    player = game.players.find(params[:player_id])

    Step.transaction do
      step = player.steps.create!(step_params)

      game_state = BuildGameState.new(game).call

      if FollowsRules.new(step, game_state).call
        CompleteTurn.new(step, game_state).call
      else
        follow_rules_service = FollowsRules.new(step, game_state)
        follow_rules_service.call
        flash.alert = follow_rules_service.errors
        raise ActiveRecord::Rollback
      end
    end

    redirect_to game
  end

  private

  def step_params
    params.require(:step).permit(:kind, :card_id, :in_response_to_step_id)
  end
end
