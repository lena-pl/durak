class DrawCards
  def initialize(game_state)
    @game_state = game_state
  end

  def call
    if !@game_state.deck.empty?
      need_to_draw = find_players_who_need_to_draw

      draws_for_players(need_to_draw).each do |player_state, amount|
        draw_cards_from_deck(player_state, amount)
      end
    end
  end

  private

  def find_players_who_need_to_draw
    @game_state.player_states.select do |player_state|
      player_state.hand.count < GameState::STANDARD_HAND_SIZE
    end
  end

  def draws_for_players(player_states)
    ideal_draw_amounts = ideal_draw_amounts(player_states)
    ideal_amount_to_draw_total = ideal_draw_amounts.values.reduce(0, &:+)

    if enough_cards_left_in_deck?(ideal_amount_to_draw_total)
      ideal_draw_amounts
    else
      split_remaining_cards_between_players(player_states)
    end
  end

  def ideal_draw_amounts(player_states)
    player_states.map do |player_state|
      [player_state, ideal_draw_amount(player_state)]
    end.to_h
  end

  def ideal_draw_amount(player_state)
    GameState::STANDARD_HAND_SIZE - player_state.hand.count
  end

  def split_remaining_cards_between_players(player_states)
    remaining_card_count = @game_state.deck.count
    amount_player_one = (remaining_card_count / player_states.count.to_f).ceil
    amount_player_two  = remaining_card_count - amount_player_one

    { player_states.first => amount_player_one, player_states.second => amount_player_two }
  end

  def enough_cards_left_in_deck?(amount_to_draw)
    @game_state.deck.count >= amount_to_draw
  end

  def draw_cards_from_deck(player_state, amount)
    amount.times { DrawFromDeck.new(@game_state, player_state, :draw_from_deck).call }
  end

end
