class StepsController < ApplicationController

  def create
    game = Game.find(params[:game_id])
    player = game.players.where(token: session["game_#{game.id}_token".to_sym]).first

    if params[:step].nil?
      service = EndTurn.new(player)
      service.call
    elsif params[:step].has_key?(:card_id)
      card = Card.find(params[:step][:card_id])
      service = PlayCard.new(player, card)
      service.call
    end

    flash.alert = service.errors if service.errors.present?
    render nothing: true
  end
end
