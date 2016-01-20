class StepsController < ApplicationController

  def create
    game = Game.find(params[:game_id])
    player = game.players.where(token: session[:current_player_token]).first

    if !params[:step]
      end_turn_service = EndTurn.new(player, game)

      end_turn_service.call

      flash.alert = end_turn_service.errors if end_turn_service.errors.present?
    elsif params[:step].has_key?(:card_id)
      play_card_service = PlayCard.new(player, params[:step][:card_id], game)

      play_card_service.call

      flash.alert = play_card_service.errors if play_card_service.errors.present?
    end

    render nothing: true
  end
end
