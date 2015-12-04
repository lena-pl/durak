class TableArrangement
  def arrange(cards)
    cards.in_groups_of(2).map do |attacking_card, defending_card|
      {attacking_card: attacking_card, defending_card: defending_card}
    end
  end
end
