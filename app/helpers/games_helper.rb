module GamesHelper
  CARD_NAMES = {11 => "J", 12 => "Q", 13 => "K", 14 => "A"}
  RED_CARDS = %w(hearts diamonds)

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
    if RED_CARDS.include?(suit)
      "red"
    else
      "black"
    end
  end

  def display_rank(rank)
    CARD_NAMES.fetch(rank, rank)
  end

  #TODO entities not ascii
  def display_suit_ascii(suit)
    if suit == "diamonds"
      "&diams;".html_safe
    else
      "&#{suit};".html_safe
    end
  end
end
