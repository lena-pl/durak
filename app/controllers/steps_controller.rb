class StepsController < ApplicationController
  def create
    game = Game.find(params[:game_id])
    player = game.players.find(params[:player_id])

    player.steps.create!(step_params)

    redirect_to game
  end

  private

  def step_params
    params.require(:step).permit(:kind, :card_id, :in_response_to_step_id)
  end
end
