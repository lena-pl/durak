class CardLocation

  def self.with_cards(cards)
    card_location = CardLocation.new

    cards.each do |card|
      card_location.add(card)
    end

    card_location
  end

  def initialize(arranger = DefaultArrangement.new)
    @cards = []
    @arranger = arranger
  end

  def add(card)
    @cards.push(card)
  end

  def delete(card)
    @cards.delete(card)
  end

  def move_to(location, card)
    delete(card)
    location.add(card)
  end

  def include?(card)
    @cards.include?(card)
  end

  def all
    @arranger.arrange(@cards)
  end
end
