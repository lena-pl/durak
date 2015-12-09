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
    if !lowest_trump(1) && !lowest_trump(2)
      @game_state.player(1)
    elsif !lowest_trump(2) && lowest_trump(1)
      @game_state.player(1)
    elsif !lowest_trump(1) && lowest_trump(2)
      @game_state.player(2)
    elsif lowest_trump(1) < lowest_trump(2)
      @game_state.player(1)
    elsif lowest_trump(2) < lowest_trump(1)
      @game_state.player(2)
    else
      @game_state.player(1)
    end
  end

  def lowest_trump(player_number)
    if !trump_suit_cards(player_number).empty?
      trump_suit_cards(player_number).sort.first.rank
    else
      false
    end
  end

  def trump_suit_cards(player_number)
    @game_state.player_hand(player_number).all.select { |card| card.suit == @game_state.trump_card.suit }
  end
end
