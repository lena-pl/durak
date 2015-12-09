class BuildGameState
  APPLY_ACTION = {
    deal: ApplyDealAction,
    draw_from_deck: ApplyDrawFromDeckAction,
    pickup_from_table: ApplyPickUpFromTableAction,
    attack: ApplyAttackAction,
    defend: ApplyDefendAction,
    discard: ApplyDiscardAction,
  }

  def initialize(game)
    @game = game
  end

  def call
    @game.actions.inject(BuildGameState.base_state(@game)) do |current_game_state, action|
      APPLY_ACTION[action.kind.to_sym].new(current_game_state, action).call
    end
  end

  def self.base_state(game)
    trump_card = game.trump_card
    deck = CardLocation.with_cards(Card.all)
    attacker = nil
    players = game.players.all
    player_hands = []
    players.count.times { player_hands.push(CardLocation.new) }
    table = CardLocation.new(TableArrangement.new)
    discard_pile = CardLocation.new
    GameState.new(trump_card, deck, players, player_hands, table, discard_pile, attacker)
  end
end
