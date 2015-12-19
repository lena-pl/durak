class DrawCards
  def initialize(game_state)
    @game_state = game_state
  end

  def call
    need_to_draw = find_players_who_need_to_draw
    total_amount_to_draw = total_amount_to_draw(find_players_who_need_to_draw)

    attacker_state = @game_state.player_state_for_player(@game_state.attacker)

    if need_to_draw.include?(attacker_state)
      need_to_draw.delete(attacker_state)
      need_to_draw.unshift(attacker_state)
    end

    if @game_state.deck.count >= total_amount_to_draw
      need_to_draw.each do |player_state|
        amount = amount_to_draw(player_state)
        pick_up_cards_from_deck(player_state, amount)
      end
    elsif @game_state.deck.count < total_amount_to_draw && !hands_equal?(need_to_draw)
      quotent = (total_amount_to_draw / need_to_draw.count).floor
      extra_cards = total_amount_to_draw - quotent
      amounts = [quotent, extra_cards]

      amounts.each do |amount|
        need_to_draw.each do |player_state|
          pick_up_cards_from_deck(player_state, amount)
        end
      end
    elsif @game_state.deck.count < total_amount_to_draw && hands_equal?(need_to_draw)
      need_to_draw.each do |player_state|
        amount = total_amount_to_draw / need_to_draw.count
        pick_up_cards_from_deck(player_state, amount)
      end
    end
  end

  private

  def find_players_who_need_to_draw
    @game_state.player_states.select do |player_state|
      player_state.hand.count < GameState::STANDARD_HAND_SIZE
    end
  end

  def total_amount_to_draw(players_who_need_to_draw)
    players_who_need_to_draw.map { |player_state| player_state.hand.count }.reduce(0, &:+)
  end

  def amount_to_draw(player_state)
    if player_state.hand.count < GameState::STANDARD_HAND_SIZE
      GameState::STANDARD_HAND_SIZE - player_state.hand.count
    else
      0
    end
  end

  def pick_up_cards_from_deck(player_state, amount)
    amount.times { PickUpFromDeck.new(@game_state, player_state, :draw_from_deck).call }
  end

  def hands_equal?(need_to_draw)
    hands_lengths = need_to_draw.map { |player_state| player_state.hand.count }
    !(hands_lengths.any? {|length| length != hands_lengths[0]})
  end
end
