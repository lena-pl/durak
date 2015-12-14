class ApplyDealAction
  def initialize(game_state, action)
    @game_state = game_state
    @action = action
  end

  def call
    player_state = @game_state.player_state_for_player(@action.player)
    card = @action.card

    if !@game_state.deck.include?(card)
      raise "Card must be in deck in order to be dealt"
    end

    @game_state.deck.delete(card)
    player_state.hand.push(card)

    @game_state.attacker = find_new_attacker
    @game_state
  end

  private

  def find_new_attacker
    if lowest_trump
      lowest_trump[:player]
    else
      @game_state.player_states.first.player
    end
  end

  def lowest_trump
    lowest_trumps.min_by { |lowest_trump| lowest_trump[:lowest_trump].rank }
  end

  def lowest_trumps
    lowest_trumps = @game_state.player_states.map do |player_state|
      { player: player_state.player,
        lowest_trump: player_state.lowest_card_with_suit(@game_state.trump_card.suit) }
    end

    lowest_trumps.reject { |lowest_trump| lowest_trump[:lowest_trump].nil? }
  end
end
