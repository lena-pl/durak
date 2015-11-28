class BuildGameState
  def initialize(game)
    @game = game
    @actions = game.actions
    @original_deck = Card.pluck(:id)
    @all_pick_up_actions = @actions.select { |action| action.kind == :draw_new_card || action.kind == :pick_up_from_table }
    @all_put_down_actions = @actions.select { |action| action.kind == :attack_with_card || action.kind == :defend_against_card }
    @discard_actions = @actions.select { |action| action.kind == :discard }
  end

  def call
    GameState.new( trump_suit, cards_in_deck, player_1_hand, player_2_hand, cards_on_table, discard_pile, attacker )
  end

  private

  def trump_suit
    @game.trump_card.suit
  end

  def cards_in_deck
    picked_up_cards = @all_pick_up_actions.map(&:active_card)
    @original_deck - picked_up_cards
  end

  def player_1_hand
    player_1_pick_ups = @all_pick_up_actions.select { |action| action.player == game.players.first }
    player_1_put_downs = @all_put_down_actions.select { |action| action.player == game.players.first }
    player_1_pick_ups - player_1_put_downs
  end

  def player_2_hand
    player_2_pick_ups = @all_pick_up_actions.select { |action| action.player == game.players.second }
    player_2_put_downs = @all_put_down_actions.select { |action| action.player == game.players.second }
    player_2_pick_ups - player_2_put_downs
  end

  def cards_on_table
    @original_deck - player_1_hand - player_2_hand - cards_in_deck - discard_pile
  end

  def discard_pile
    @discard_actions.map(&:active_card)
  end

  def attacker
    if @discard_actions.last.player == game.players.first
      @game.players.second
    elsif @discard_actions.last.player == game.players.second
      @game.players.first
    end
  end
end
