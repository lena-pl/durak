class PickUpFromDeck
  def initialize(game_state, player_state)
    @game_state = game_state
    @player_state = player_state
  end

  def call
    deck = game_state.deck

    if deck.count == 1
      card_to_deal = @game_state.trump_card
    else
      card_to_deal = deck.cards.reject {|card| card == @game_state.trump_card }.sample
    end

    player_state.steps.create!(kind: :deal, card: card_to_deal)
  end
end
