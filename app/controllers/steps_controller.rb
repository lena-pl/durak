class StepsController < ApplicationController
  def create
    game = Game.find(params[:game_id])
    player = game.players.find(params[:player_id])

    step = player.steps.create!(step_params)

    if (BuildGameState.new(game).call.deck.empty?) && (step.discard? || step.pick_up_from_table?)
      game_state = BuildGameState.new(game).call
      DrawCards.new(game_state).call
    end

    redirect_to game
  end

  private

  def step_params
    params.require(:step).permit(:kind, :card_id, :in_response_to_step_id)
  end
end
