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
    self.delete(card)
    location.add(card)
  end

  def include?(card)
    @cards.include?(card)
  end

  def all
    @arranger.arrange(@cards)
  end
end

class DefaultArrangement
  def arrange(cards)
    cards
  end
end

class TableArrangement
  def arrange(cards)
    pairs = []
    index = 0

    while index < cards.length
      pairs.push({ :attacking_card => cards[index], :defending_card => cards[index + 1] })
      index += 2
    end

    pairs
  end
end
