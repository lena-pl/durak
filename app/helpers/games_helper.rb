module GamesHelper
  def player_name(player)
    if player == @game.players.first
      "Player 1"
    elsif player == @game.players.second
      "Player 2"
    end
  end

  def opponent
    if @current_player == @game_state.attacker
      @game_state.defender
    else
      @game_state.attacker
    end
  end

  def suit_colour(suit)
    if suit == "hearts" || suit == "diamonds"
      "red"
    else
      "black"
    end
  end

  def display_rank(rank)
    return rank unless rank > 10

    if rank == 11
      "J"
    elsif rank == 12
      "Q"
    elsif rank == 13
      "K"
    elsif rank == 14
      "A"
    end
  end

  def display_suit_ascii(suit)
    if suit == "diamonds"
      "&diams;"
    else
      "&#{suit};"
    end
  end
end
