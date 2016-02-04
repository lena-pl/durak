class DrawFromDeck
  def initialize(game_state, player_state, kind)
    @game_state = game_state
    @player_state = player_state
    @kind = kind
  end

  def call
    deck = @game_state.deck

    if deck.empty?
      raise "Cannot draw from empty deck"
    elsif deck.count == 1
      card_to_draw = @game_state.trump_card
    else
      card_to_draw = non_trump_cards.sample
    end

    @game_state.deck.delete(card_to_draw)
    @player_state.player.steps.create!(kind: @kind, card: card_to_draw)
  end

  private

  def non_trump_cards
    @game_state.deck.cards.reject {|card| card == @game_state.trump_card }
  end
end
