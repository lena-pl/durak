class CardLocation
  attr_reader :cards

  delegate :push, :delete, :include?, :count, :empty?, :select, :clear, to: :cards

  def self.with_cards(cards)
    CardLocation.new.tap do |card_location|
      card_location.push(*cards)
    end
  end

  def initialize(arranger = DefaultArrangement.new)
    @cards = []
    @arranger = arranger
  end

  def arranged
    @arranger.arrange(@cards)
  end
end
