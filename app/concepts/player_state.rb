class PlayerState
  attr_reader :player, :hand

  def initialize(player:, hand:)
    @player = player
    @hand = hand
  end

  def lowest_card_with_suit(suit)
    cards_with_suit(suit).min_by(&:rank)
  end

  private

  def cards_with_suit(suit)
    @hand.select { |card| card.suit == suit }
  end
end
