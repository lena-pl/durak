require 'rails_helper'
require 'test_game'

describe "Full Game" do
  fixtures :cards

  let(:trump_card) { cards(:clubs_6) }
  let(:test_game) { TestGame.new(trump_card) }
  let(:game) { test_game.game_model }
  let(:player_one) { game.players.first }
  let(:player_two) { game.players.second }

  it "works, because you're worth it. " do
    deal_player_one_cards
    deal_player_two_cards

    # ROUND ONE. FIGHT.

    attack_action = test_game.attack(player_two, cards(:spades_7))
    game.reload
    expect(game_state.attacker).to eq player_two
    expect(game_state.table.cards).to eq [cards(:spades_7)]
    expect(player_two_hand.cards.count).to eq 5
    expect(player_two_hand.cards).to_not include cards(:spades_7)
    expect(game_state.table.arranged.first[:attacking_card]).to eq cards(:spades_7)
    expect(game_state.table.arranged.first[:defending_card]).to be_nil

    test_game.defend(player_one, cards(:spades_13), attack_action)
    game.reload
    expect(game_state.attacker).to eq player_two
    expect(game_state.table.cards).to eq [cards(:spades_7), cards(:spades_13)]
    expect(player_one_hand.cards.count).to eq 5
    expect(player_one_hand.cards).to_not include cards(:spades_13)
    expect(game_state.table.arranged.first[:attacking_card]).to eq cards(:spades_7)
    expect(game_state.table.arranged.first[:defending_card]).to eq cards(:spades_13)

    test_game.discard(player_two, cards(:spades_13))
    game.reload
    expect(game_state.attacker).to eq player_one
    expect(game_state.table.cards).to eq [cards(:spades_7)]
    expect(game_state.discard_pile.cards).to eq [cards(:spades_13)]
    expect(game_state.table.arranged.first[:attacking_card]).to eq cards(:spades_7)
    expect(game_state.table.arranged.first[:defending_card]).to be_nil

    test_game.discard(player_two, cards(:spades_7))
    game.reload
    expect(game_state.table).to be_empty
    expect(game_state.discard_pile.cards).to eq [cards(:spades_13), cards(:spades_7)]

    test_game.draw_from_deck(player_two, cards(:spades_10))
    game.reload
    expect(game_state.deck).to_not include cards(:spades_10)
    expect(game_state.deck.count).to eq 23
    expect(player_two_hand).to include(cards(:spades_10))
    expect(player_two_hand.count).to eq 6

    test_game.draw_from_deck(player_one, cards(:spades_14))
    game.reload
    expect(game_state.deck).to_not include cards(:spades_14)
    expect(game_state.deck.count).to eq 22
    expect(player_one_hand).to include(cards(:spades_14))
    expect(player_one_hand.count).to eq 6

    # ROUND TWO. FIGHT.

    attack_action = test_game.attack(player_one, cards(:spades_6))
    game.reload
    expect(game_state.attacker).to eq player_one
    expect(game_state.table.cards).to eq [cards(:spades_6)]
    expect(player_one_hand.cards.count).to eq 5
    expect(player_one_hand.cards).to_not include cards(:spades_6)
    expect(game_state.table.arranged.first[:attacking_card]).to eq cards(:spades_6)
    expect(game_state.table.arranged.first[:defending_card]).to be_nil

    test_game.defend(player_two, cards(:spades_10), attack_action)
    game.reload
    expect(game_state.attacker).to eq player_one
    expect(game_state.table.cards).to eq [cards(:spades_6), cards(:spades_10)]
    expect(player_two_hand.cards.count).to eq 5
    expect(player_two_hand.cards).to_not include cards(:spades_10)
    expect(game_state.table.arranged.first[:attacking_card]).to eq cards(:spades_6)
    expect(game_state.table.arranged.first[:defending_card]).to eq cards(:spades_10)

    test_game.discard(player_one, cards(:spades_10))
    game.reload
    expect(game_state.attacker).to eq player_two
    expect(game_state.table.cards).to eq [cards(:spades_6)]
    expect(game_state.discard_pile.count).to eq 3
    expect(game_state.discard_pile).to include(cards(:spades_10))
    expect(game_state.table.arranged.first[:attacking_card]).to eq cards(:spades_6)
    expect(game_state.table.arranged.first[:defending_card]).to be_nil

    test_game.discard(player_one, cards(:spades_6))
    game.reload
    expect(game_state.table).to be_empty
    expect(game_state.discard_pile.count).to eq 4
    expect(game_state.discard_pile).to include(cards(:spades_10), cards(:spades_6))

    test_game.draw_from_deck(player_one, cards(:diamonds_12))
    game.reload
    expect(game_state.deck).to_not include cards(:diamonds_12)
    expect(game_state.deck.count).to eq 21
    expect(player_one_hand).to include(cards(:diamonds_12))
    expect(player_one_hand.count).to eq 6

    test_game.draw_from_deck(player_two, cards(:hearts_11))
    game.reload
    expect(game_state.deck).to_not include cards(:hearts_11)
    expect(game_state.deck.count).to eq 20
    expect(player_two_hand).to include(cards(:hearts_11))
    expect(player_two_hand.count).to eq 6

    # ROUND THREE. FIGHT.

    attack_action = test_game.attack(player_two, cards(:hearts_6))
    game.reload
    expect(game_state.attacker).to eq player_two
    expect(game_state.table.cards).to eq [cards(:hearts_6)]
    expect(player_two_hand.cards.count).to eq 5
    expect(player_two_hand.cards).to_not include cards(:hearts_6)
    expect(game_state.table.arranged.first[:attacking_card]).to eq cards(:hearts_6)
    expect(game_state.table.arranged.first[:defending_card]).to be_nil

    test_game.defend(player_one, cards(:hearts_7), attack_action)
    game.reload
    expect(game_state.attacker).to eq player_two
    expect(game_state.table.cards).to eq [cards(:hearts_6), cards(:hearts_7)]
    expect(player_one_hand.cards.count).to eq 5
    expect(player_one_hand.cards).to_not include cards(:hearts_7)
    expect(game_state.table.arranged.first[:attacking_card]).to eq cards(:hearts_6)
    expect(game_state.table.arranged.first[:defending_card]).to eq cards(:hearts_7)

    test_game.discard(player_two, cards(:hearts_7))
    game.reload
    expect(game_state.attacker).to eq player_one
    expect(game_state.table.cards).to eq [cards(:hearts_6)]
    expect(game_state.discard_pile.count).to eq 5
    expect(game_state.discard_pile).to include(cards(:hearts_7))
    expect(game_state.table.arranged.first[:attacking_card]).to eq cards(:hearts_6)
    expect(game_state.table.arranged.first[:defending_card]).to be_nil

    test_game.discard(player_two, cards(:hearts_6))
    game.reload
    expect(game_state.table).to be_empty
    expect(game_state.discard_pile.count).to eq 6
    expect(game_state.discard_pile).to include(cards(:hearts_7), cards(:hearts_6))

    test_game.draw_from_deck(player_two, cards(:diamonds_11))
    game.reload
    expect(game_state.deck).to_not include cards(:diamonds_11)
    expect(game_state.deck.count).to eq 19
    expect(player_two_hand).to include(cards(:diamonds_11))
    expect(player_two_hand.count).to eq 6

    test_game.draw_from_deck(player_one, cards(:hearts_8))
    game.reload
    expect(game_state.deck).to_not include cards(:hearts_8)
    expect(game_state.deck.count).to eq 18
    expect(player_one_hand).to include(cards(:hearts_8))
    expect(player_one_hand.count).to eq 6

    # ROUND FOUR. FIGHT.

    attack_action = test_game.attack(player_one, cards(:hearts_8))
    game.reload
    expect(game_state.attacker).to eq player_one
    expect(game_state.table.cards).to eq [cards(:hearts_8)]
    expect(player_one_hand.cards.count).to eq 5
    expect(player_one_hand.cards).to_not include cards(:hearts_8)
    expect(game_state.table.arranged.first[:attacking_card]).to eq cards(:hearts_8)
    expect(game_state.table.arranged.first[:defending_card]).to be_nil

    test_game.defend(player_two, cards(:hearts_12), attack_action)
    game.reload
    expect(game_state.attacker).to eq player_one
    expect(game_state.table.cards).to eq [cards(:hearts_8), cards(:hearts_12)]
    expect(player_two_hand.cards.count).to eq 5
    expect(player_two_hand.cards).to_not include cards(:hearts_12)
    expect(game_state.table.arranged.first[:attacking_card]).to eq cards(:hearts_8)
    expect(game_state.table.arranged.first[:defending_card]).to eq cards(:hearts_12)

    attack_action = test_game.attack(player_one, cards(:diamonds_12))
    game.reload
    expect(game_state.attacker).to eq player_one
    expect(game_state.table.cards).to eq [cards(:hearts_8), cards(:hearts_12), cards(:diamonds_12)]
    expect(player_one_hand.cards.count).to eq 4
    expect(player_one_hand.cards).to_not include cards(:diamonds_12)
    expect(game_state.table.arranged.second[:attacking_card]).to eq cards(:diamonds_12)
    expect(game_state.table.arranged.second[:defending_card]).to be_nil

    test_game.defend(player_two, cards(:clubs_7), attack_action)
    game.reload
    expect(game_state.attacker).to eq player_one
    expect(game_state.table.cards).to eq [cards(:hearts_8), cards(:hearts_12), cards(:diamonds_12), cards(:clubs_7)]
    expect(player_two_hand.cards.count).to eq 4
    expect(player_two_hand.cards).to_not include cards(:clubs_7)
    expect(game_state.table.arranged.second[:attacking_card]).to eq cards(:diamonds_12)
    expect(game_state.table.arranged.second[:defending_card]).to eq cards(:clubs_7)

    test_game.discard(player_one, cards(:clubs_7))
    game.reload
    expect(game_state.attacker).to eq player_two
    expect(game_state.table.cards).to eq [cards(:hearts_8), cards(:hearts_12), cards(:diamonds_12)]
    expect(game_state.discard_pile.count).to eq 7
    expect(game_state.discard_pile).to include(cards(:clubs_7))
    expect(game_state.table.arranged.second[:attacking_card]).to eq cards(:diamonds_12)
    expect(game_state.table.arranged.second[:defending_card]).to be_nil

    test_game.discard(player_one, cards(:diamonds_12))
    game.reload
    expect(game_state.attacker).to eq player_two
    expect(game_state.table.cards).to eq [cards(:hearts_8), cards(:hearts_12)]
    expect(game_state.discard_pile.count).to eq 8
    expect(game_state.discard_pile).to include(cards(:diamonds_12))

    test_game.discard(player_one, cards(:hearts_12))
    game.reload
    expect(game_state.attacker).to eq player_two
    expect(game_state.table.cards).to eq [cards(:hearts_8)]
    expect(game_state.discard_pile.count).to eq 9
    expect(game_state.discard_pile).to include(cards(:hearts_12))
    expect(game_state.table.arranged.first[:attacking_card]).to eq cards(:hearts_8)
    expect(game_state.table.arranged.first[:defending_card]).to be_nil

    test_game.discard(player_one, cards(:hearts_8))
    game.reload
    expect(game_state.attacker).to eq player_two
    expect(game_state.table.cards).to be_empty
    expect(game_state.discard_pile.count).to eq 10
    expect(game_state.discard_pile).to include(cards(:hearts_8))

    test_game.draw_from_deck(player_one, cards(:clubs_13))
    game.reload
    expect(game_state.deck).to_not include cards(:clubs_13)
    expect(game_state.deck.count).to eq 17
    expect(player_one_hand).to include(cards(:clubs_13))
    expect(player_one_hand.count).to eq 5

    test_game.draw_from_deck(player_one, cards(:hearts_14))
    game.reload
    expect(game_state.deck).to_not include cards(:hearts_14)
    expect(game_state.deck.count).to eq 16
    expect(player_one_hand).to include(cards(:hearts_14))
    expect(player_one_hand.count).to eq 6

    test_game.draw_from_deck(player_two, cards(:diamonds_13))
    game.reload
    expect(game_state.deck).to_not include cards(:diamonds_13)
    expect(game_state.deck.count).to eq 15
    expect(player_two_hand).to include(cards(:diamonds_13))
    expect(player_two_hand.count).to eq 5

    test_game.draw_from_deck(player_two, cards(:diamonds_9))
    game.reload
    expect(game_state.deck).to_not include cards(:diamonds_9)
    expect(game_state.deck.count).to eq 14
    expect(player_two_hand).to include(cards(:diamonds_9))
    expect(player_two_hand.count).to eq 6
  end

  private

  def deal_player_one_cards
    test_game.deal_card(player_one, cards(:spades_6))
    game.reload
    expect(game_state.deck.count).to eq 35
    expect(game_state.deck).to_not include cards(:spades_6)
    expect(player_one_hand.cards).to eq [cards(:spades_6)]
    expect(game_state.attacker).to eq player_one

    test_game.deal_card(player_one, cards(:hearts_7))
    game.reload
    expect(game_state.deck.count).to eq 34
    expect(game_state.deck).to_not include cards(:hearts_7)
    expect(player_one_hand.cards).to eq [cards(:spades_6),
                                                             cards(:hearts_7)]
    expect(game_state.attacker).to eq player_one

    test_game.deal_card(player_one, cards(:clubs_14))
    game.reload
    expect(game_state.deck.count).to eq 33
    expect(game_state.deck).to_not include cards(:clubs_14)
    expect(player_one_hand.cards).to eq [cards(:spades_6),
                                                             cards(:hearts_7),
                                                             cards(:clubs_14)]
    expect(game_state.attacker).to eq player_one

    test_game.deal_card(player_one, cards(:hearts_9))
    game.reload
    expect(game_state.deck.count).to eq 32
    expect(game_state.deck).to_not include cards(:hearts_9)
    expect(player_one_hand.cards).to eq [cards(:spades_6),
                                                             cards(:hearts_7),
                                                             cards(:clubs_14),
                                                             cards(:hearts_9)]
    expect(game_state.attacker).to eq player_one

    test_game.deal_card(player_one, cards(:spades_13))
    game.reload
    expect(game_state.deck.count).to eq 31
    expect(game_state.deck).to_not include cards(:spades_13)
    expect(player_one_hand.cards).to eq [cards(:spades_6),
                                                             cards(:hearts_7),
                                                             cards(:clubs_14),
                                                             cards(:hearts_9),
                                                             cards(:spades_13)]
    expect(game_state.attacker).to eq player_one

    test_game.deal_card(player_one, cards(:clubs_9))
    game.reload
    expect(game_state.deck.count).to eq 30
    expect(game_state.deck).to_not include cards(:clubs_9)
    expect(player_one_hand.cards).to eq [cards(:spades_6),
                                                             cards(:hearts_7),
                                                             cards(:clubs_14),
                                                             cards(:hearts_9),
                                                             cards(:spades_13),
                                                             cards(:clubs_9)]
    expect(game_state.attacker).to eq player_one
  end

  def deal_player_two_cards
    test_game.deal_card(player_two, cards(:spades_11))
    game.reload
    expect(game_state.deck.count).to eq 29
    expect(game_state.deck).to_not include cards(:spades_11)
    expect(player_two_hand.cards).to eq [cards(:spades_11)]
    expect(game_state.attacker).to eq player_one

    test_game.deal_card(player_two, cards(:clubs_7))
    game.reload
    expect(game_state.deck.count).to eq 28
    expect(game_state.deck).to_not include cards(:clubs_7)
    expect(player_two_hand.cards).to eq [cards(:spades_11),
                                                             cards(:clubs_7)]
    expect(game_state.attacker).to eq player_two

    test_game.deal_card(player_two, cards(:spades_7))
    game.reload
    expect(game_state.deck.count).to eq 27
    expect(game_state.deck).to_not include cards(:spades_7)
    expect(player_two_hand.cards).to eq [cards(:spades_11),
                                                             cards(:clubs_7),
                                                             cards(:spades_7)]
    expect(game_state.attacker).to eq player_two

    test_game.deal_card(player_two, cards(:hearts_12))
    game.reload
    expect(game_state.deck.count).to eq 26
    expect(game_state.deck).to_not include cards(:hearts_12)
    expect(player_two_hand.cards).to eq [cards(:spades_11),
                                                             cards(:clubs_7),
                                                             cards(:spades_7),
                                                             cards(:hearts_12)]
    expect(game_state.attacker).to eq player_two

    test_game.deal_card(player_two, cards(:clubs_8))
    game.reload
    expect(game_state.deck.count).to eq 25
    expect(game_state.deck).to_not include cards(:clubs_8)
    expect(player_two_hand.cards).to eq [cards(:spades_11),
                                                             cards(:clubs_7),
                                                             cards(:spades_7),
                                                             cards(:hearts_12),
                                                             cards(:clubs_8)]
    expect(game_state.attacker).to eq player_two

    test_game.deal_card(player_two, cards(:hearts_6))
    game.reload
    expect(game_state.deck.count).to eq 24
    expect(game_state.deck).to_not include cards(:hearts_6)
    expect(player_two_hand.cards).to eq [cards(:spades_11),
                                                             cards(:clubs_7),
                                                             cards(:spades_7),
                                                             cards(:hearts_12),
                                                             cards(:clubs_8),
                                                             cards(:hearts_6)]
    expect(game_state.attacker).to eq player_two
  end

  def game_state
    BuildGameState.new(game).call
  end

  def player_one_hand
    game_state.player_states.first.hand
  end

  def player_two_hand
    game_state.player_states.second.hand
  end
end
