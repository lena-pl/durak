class ApplyDealAction
  def initialize(game_state, action)
    @game_state = game_state
    @action = action
  end

  def call
    card = @action.card

    @game_state.deck.delete(card)

    if @action.player == @game_state.player(1)
      @game_state.player_hand(1).add(card)
    elsif @action.player == @game_state.player(2)
      @game_state.player_hand(2).add(card)
    end

    @game_state.attacker = find_new_attacker

    @game_state
  end

  private

  def find_new_attacker
    if !has_trump?(1) && !has_trump?(2)
      @game_state.player(1)
    elsif !has_trump?(2) && has_trump?(1)
      @game_state.player(1)
    elsif !has_trump?(1) && has_trump?(2)
      @game_state.player(2)
    elsif lowest_trump(1) < lowest_trump(2)
      @game_state.player(1)
    elsif lowest_trump(2) < lowest_trump(1)
      @game_state.player(2)
    end
  end

  def has_trump?(player_number)
    !trump_suit_cards(player_number).empty?
  end

  def lowest_trump(player_number)
    if has_trump?(player_number)
      trump_suit_cards(player_number).sort.first.rank
    end
  end

  def trump_suit_cards(player_number)
    @game_state.player_hand(player_number).all.select { |card| card.suit == @game_state.trump_card.suit }
  end
end
