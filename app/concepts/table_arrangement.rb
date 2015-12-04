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
