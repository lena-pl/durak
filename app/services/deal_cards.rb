class DealCards
  NUMBER_OF_CARDS = 6

  def initialize(game)
    @game = game
  end

  def call
    @game.players.each do |player|
      cards_to_deal = game_state.deck.cards.sample(NUMBER_OF_CARDS)

      cards_to_deal.each do |card|
        player.actions.create!(kind: :deal, card: card)
      end
    end
  end

  def game_state
    BuildGameState.new(@game).call
  end
end
