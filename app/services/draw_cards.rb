class DrawCards
  def initialize()
    @game_state = game_state
  end

  def call
    need_to_draw = find_players_who_need_to_draw
    amount_to_draw = calculate_amount_to_draw(players_who_need_to_draw)

    if @game_state.deck.count >= amount_to_draw
      attacker_state = @game_state.player_state_for_player(@game_state.attacker)

      if need_to_draw.include?(attacker_state)
        need_to_draw.delete(attacker_state)
        need_to_draw.shift(attacker_state)
      end

      need_to_draw.each do |player_state|
        PickUpCardFromDeck.new(@game_state, player_state)
      end
    end
  end

  private

  def find_players_who_need_to_draw
    @game_state.player_states.select do |player_state|
      player_state.hand.count < GameState::STANDARD_HAND_SIZE
    end
  end

  def calculate_amount_to_draw(players_who_need_to_draw)
    players_who_need_to_draw.map { |player_state| player_state.hand.count }.reduce(&:+)
  end

  def pick_up_cards_from_deck(player_state, amount)
    amount.times { PickUpCardFromDeck.new(@game_state, player_state) }
  end
end
