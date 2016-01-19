class TableArrangement
  Pair = Struct.new(:attacking_card, :defending_card) do
    def defended?
      defending_card.present?
    end
  end

  def arrange(cards)
    cards.in_groups_of(2).map do |attacking_card, defending_card|
      Pair.new(attacking_card, defending_card)
    end
  end
end
