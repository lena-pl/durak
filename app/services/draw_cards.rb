class DrawCards
  def initialize(game_state)
    @game_state = game_state
  end

  def call
    need_to_draw = find_players_who_need_to_draw
    total_amount_to_draw = total_amount_to_draw(find_players_who_need_to_draw)

    if @game_state.deck.count >= total_amount_to_draw
      attacker_state = @game_state.player_state_for_player(@game_state.attacker)

      if need_to_draw.include?(attacker_state)
        need_to_draw.delete(attacker_state)
        need_to_draw.unshift(attacker_state)
      end

      need_to_draw.each do |player_state|
        amount = amount_to_draw(player_state)
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
end
