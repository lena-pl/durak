class BuildGameState
  def initialize(game)
    @game = game
    @actions = game.actions
    @original_deck = Card.all
    @all_pick_up_actions = @actions.draw_new_card + @actions.pick_up_from_table
    @all_put_down_actions = @actions.attack_with_card + @actions.defend_against_card
    @discard_actions = @actions.discard
  end

  def call
    GameState.new(trump_suit, cards_in_deck, player_one_hand, player_two_hand, discard_pile, cards_on_table, attacker)
  end

  private

  def trump_suit
    @game.trump_card.suit
  end

  def cards_in_deck
    picked_up_from_deck = @actions.draw_new_card.map(&:active_card)
    @original_deck - picked_up_from_deck
  end

  def player_one_hand
    player_one_pick_ups = pickups_for_player(player_one)
    player_one_put_downs = putdowns_for_player(player_one)
    player_one_pick_ups - player_one_put_downs
  end

  def player_two_hand
    player_two_pick_ups = pickups_for_player(player_two)
    player_two_put_downs = putdowns_for_player(player_two)
    player_two_pick_ups - player_two_put_downs
  end

  def discard_pile
    @discard_actions.map(&:active_card)
  end

  def cards_on_table
    @original_deck - player_one_hand - player_two_hand - cards_in_deck - discard_pile
  end

  def attacker
    if @discard_actions.empty?
      find_starting_player
    elsif @discard_actions.last.player == player_one
      player_two
    elsif @discard_actions.last.player == player_two
      player_one
    end
  end

  def player_one
    @game.players.first
  end

  def player_two
    @game.players.second
  end

  def find_starting_player
    player_one_trumps = player_one_hand.select {|card| card.suit == trump_suit }
    player_two_trumps = player_two_hand.select {|card| card.suit == trump_suit }

    if player_one_trumps.empty? && player_two_trumps.empty?
      player_one # TODO make this random
    elsif player_one_trumps.empty? && !player_two_trumps.empty?
      player_two
    elsif player_two_trumps.empty? && !player_one_trumps.empty?
      player_one
    else
      player_one_lowest_trump = player_one_trumps.sort_by(&:rank).first.rank
      player_two_lowest_trump = player_two_trumps.sort_by(&:rank).first.rank

      if player_one_lowest_trump < player_two_lowest_trump
        player_one
      else
        player_two
      end
    end
  end

  def pickups_for_player(player)
    pickup_actions = @all_pick_up_actions.select { |action| action.player == player }
    pickup_actions.map(&:active_card)
  end

  def putdowns_for_player(player)
    putdown_actions = @all_put_down_actions.select { |action| action.player == player }
    putdown_actions.map(&:active_card)
  end
end
