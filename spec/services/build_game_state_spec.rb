require 'rails_helper'

RSpec.describe BuildGameState do
  def card(rank, suit)
    Card.find_by!(rank: rank, suit: Card.suits[suit])
  end

  def initialize_deck
    Card.suits.each do |suit, enumeration|
      6.upto(14) do |rank|
        Card.create!(rank: rank, suit: suit)
      end
    end
  end

  def create_action(kind, game, player, active_card, passive_card = nil)
    Action.create!(:kind => kind, :game => game, :player => player, :active_card => active_card, :passive_card => passive_card)
  end

  def draw_cards_from_deck(player, cards)
    cards.each do |card|
      create_action(:draw_new_card, game, player, card)
    end
  end

  def attack_with_cards(player, cards)
    cards.each do |card|
      create_action(:attack_with_card, game, player, card)
    end
  end

  def defend_against_cards(player, card_pairs)
    card_pairs.each do |card_pair|
      create_action(:defend_against_card, game, player, card_pair[:with], card_pair[:against])
    end
  end

  def discard_cards(player, cards)
    cards.each do |card|
      create_action(:discard, game, player, card)
    end
  end

  before(:all) do
    initialize_deck
  end

  subject(:game_state) { BuildGameState.new(game).call }
  let(:trump_card) { card(9, "hearts") }
  let!(:game) { Game.create!(:trump_card => trump_card) }
  let!(:player_one) { Player.create!(:game => game) }
  let!(:player_two) { Player.create!(:game => game) }

  let(:player_one_start_hand) { [card(7, "hearts"), card(11, "diamonds"),
                                 card(9, "hearts"), card(12, "clubs"),
                                 card(10, "clubs"), card(14, "hearts")] }

  let(:player_two_start_hand) { [card(13, "spades"), card(13, "diamonds"),
                                 card(10, "diamonds"), card(10, "hearts"),
                                 card(11, "clubs"), card(11, "hearts")] }

  describe "#call" do
    context "when the trump card is the 10 of hearts" do
      let!(:ten_of_hearts) { card(10, "hearts") }
      let!(:game) { Game.create!(:trump_card => ten_of_hearts) }

      before do
        draw_cards_from_deck(player_one, player_one_start_hand)
        draw_cards_from_deck(player_two, player_two_start_hand)
      end

      it "returns the game state with hearts as the trump suit " do
        expect(game_state.trump_suit).to eq "hearts"
      end
    end

    context "when the trump card is the 8 of spades" do
      let!(:eight_of_spades) { card(8, "spades") }
      let!(:game) { Game.create!(:trump_card => eight_of_spades) }

      before do
        draw_cards_from_deck(player_one, player_one_start_hand)
        draw_cards_from_deck(player_two, player_two_start_hand)
      end

      it "returns the game state with spades as the trump suit " do
        expect(game_state.trump_suit).to eq "spades"
      end
    end

    context "at the start of the game, after cards have been dealt" do
      before do
        draw_cards_from_deck(player_one, player_one_start_hand)
        draw_cards_from_deck(player_two, player_two_start_hand)
      end

      context "when player one has the lowest trump suit" do
        let(:trump_card) { card(8, "hearts") }

        let(:player_one_start_hand) {[
          card(7, "hearts"),
          card(11, "hearts"),
          card(10, "hearts"),
          card(14, "diamonds")
        ]}

        let(:player_two_start_hand) {[
          card(12, "hearts"),
          card(11, "spades"),
          card(7, "spades"),
          card(14, "clubs")
        ]}

        it "makes player one the first attacker" do
          expect(game_state.attacker).to eq player_one
        end
      end

      context "when player two has the lowest trump suit" do
        let(:trump_card) { card(8, "spades") }

        let(:player_one_start_hand) {[
          card(7, "hearts"),
          card(11, "hearts"),
          card(10, "hearts"),
          card(14, "spades")
        ]}

        let(:player_two_start_hand) {[
          card(12, "hearts"),
          card(11, "spades"),
          card(7, "spades"),
          card(14, "clubs")
        ]}

        it "makes player two the first attacker" do
          expect(game_state.attacker).to eq player_two
        end
      end

      context "when only player one has a trump card" do
        let(:trump_card) { card(8, "spades") }

        let(:player_one_start_hand) {[
          card(7, "hearts"),
          card(11, "hearts"),
          card(10, "hearts"),
          card(14, "spades")
        ]}

        let(:player_two_start_hand) {[
          card(12, "hearts"),
          card(11, "diamonds"),
          card(7, "diamonds"),
          card(14, "clubs")
        ]}

        it "makes player one the first attacker" do
          expect(game_state.attacker).to eq player_one
        end
      end

      context "when only player two has a trump card" do
        let(:trump_card) { card(8, "spades") }

        let(:player_one_start_hand) {[
          card(7, "hearts"),
          card(11, "hearts"),
          card(10, "hearts"),
          card(14, "clubs")
        ]}

        let(:player_two_start_hand) {[
          card(12, "hearts"),
          card(11, "diamonds"),
          card(7, "diamonds"),
          card(14, "spades")
        ]}

        it "makes player two the first attacker" do
          expect(game_state.attacker).to eq player_two
        end
      end

      context "when neither player has a trump card" do
        let(:trump_card) { card(8, "spades") }

        let(:player_one_start_hand) {[
          card(7, "hearts"),
          card(11, "hearts"),
          card(10, "hearts"),
          card(14, "diamonds")
        ]}

        let(:player_two_start_hand) {[
          card(12, "hearts"),
          card(11, "diamonds"),
          card(7, "diamonds"),
          card(14, "clubs")
        ]}

        it "makes player one the first attacker" do
          expect(game_state.attacker).to eq player_one
        end
      end

      it "has 12 less cards in the deck" do
        expect(game_state.cards_in_deck.count).to eq Card.all.count - 12
      end

      it "has no cards that have been drawn in the deck" do
        expected_deck = Card.all - player_one_start_hand - player_two_start_hand
        expect(game_state.cards_in_deck).to eq expected_deck
      end

      it "returns a game state with the correct cards in player one's hand" do
        expect(game_state.player_one_hand).to eq player_one_start_hand
      end

      it "returns a game state with the correct cards in player two's hand" do
        expect(game_state.player_two_hand).to eq player_two_start_hand
      end

      it "has no cards on the table" do
        expect(game_state.cards_on_table).to be_empty
      end

      it "has no cards in the discard pile" do
        expect(game_state.discard_pile).to be_empty
      end
    end

    context "when player one attacks with 3 cards from their start hand" do
      let(:cards_to_attack_with) {[
        player_one_start_hand[0],
        player_one_start_hand[1],
        player_one_start_hand[2],
      ]}

      before do
        draw_cards_from_deck(player_one, player_one_start_hand)
        attack_with_cards(player_one, cards_to_attack_with)
      end

      it "removes 3 cards from their hand" do
        expect(game_state.player_one_hand.length).to eq player_one_start_hand.length - 3
      end

      it "leaves unaffected cards in their hand" do
        expect(game_state.player_one_hand).to eq player_one_start_hand - cards_to_attack_with
      end

      it "puts 3 cards onto the table" do
        expect(game_state.cards_on_table.length).to eq cards_to_attack_with.length
      end

      it "puts those cards onto the table" do
        expect(game_state.cards_on_table).to include(cards_to_attack_with[0], cards_to_attack_with[1], cards_to_attack_with[2])
      end

      it "doesn't affect the discard pile" do
        expect(game_state.discard_pile).to be_empty
      end
    end

    context "when player two attacks with 5 cards from their start hand" do
      let(:cards_to_attack_with) {[
        player_two_start_hand[0],
        player_two_start_hand[1],
        player_two_start_hand[2],
        player_two_start_hand[3],
        player_two_start_hand[4],
      ]}

      before do
        draw_cards_from_deck(player_two, player_two_start_hand)
        attack_with_cards(player_two, cards_to_attack_with)
      end

      it "removes 5 cards from their hand" do
        expect(game_state.player_two_hand.length).to eq player_two_start_hand.length - 5
      end

      it "leaves unaffected cards in their hand" do
        expect(game_state.player_two_hand).to eq player_two_start_hand - cards_to_attack_with
      end

      it "puts 5 cards onto the table" do
        expect(game_state.cards_on_table.length).to eq cards_to_attack_with.length
      end

      it "puts those cards onto the table" do
        expect(game_state.cards_on_table).to include(cards_to_attack_with[0], cards_to_attack_with[1], cards_to_attack_with[2], cards_to_attack_with[3], cards_to_attack_with[4])
      end

      it "doesn't affect the discard pile" do
        expect(game_state.discard_pile).to be_empty
      end
    end

    context "when player one defends against 2 cards that player two attacked with" do
      let(:cards_to_attack_with) {[
        player_two_start_hand[0],
        player_two_start_hand[1],
      ]}

      let(:cards_to_defend_with) {[
        { :with => player_one_start_hand[0], :against => player_two_start_hand[0] },
        { :with => player_one_start_hand[1], :against => player_two_start_hand[1] },
      ]}

      before do
        draw_cards_from_deck(player_one, player_one_start_hand)
        draw_cards_from_deck(player_two, player_two_start_hand)

        attack_with_cards(player_two, cards_to_attack_with)
        defend_against_cards(player_one, cards_to_defend_with)
      end

      it "removes 2 cards from player_two's hand" do
        expect(game_state.player_two_hand.length).to eq player_two_start_hand.length - 2
      end

      it "removes 2 cards from player_one's hand" do
        expect(game_state.player_one_hand.length).to eq player_one_start_hand.length - 2
      end

      it "puts 4 cards onto the table" do
        expect(game_state.cards_on_table.length).to eq cards_to_attack_with.length + cards_to_defend_with.length
      end

      it "puts those cards onto the table" do
        expect(game_state.cards_on_table).to include(cards_to_attack_with[0], cards_to_attack_with[1],
                  cards_to_defend_with[0][:with], cards_to_defend_with[1][:with])
      end

      it "doesn't affect the discard pile" do
        expect(game_state.discard_pile).to be_empty
      end

      context "when player two discards the play" do
       let(:cards_to_discard) {[
         cards_to_attack_with[0],
         cards_to_attack_with[1],
         cards_to_defend_with[0][:with],
         cards_to_defend_with[1][:with]
       ]}

        before do
          discard_cards(player_two, cards_to_discard)
        end

        it "puts 4 cards in the discard pile" do
          expect(game_state.discard_pile.length).to eq cards_to_discard.length
        end

        it "puts those cards in the discard pile" do
          expect(game_state.discard_pile).to include(cards_to_discard[0], cards_to_discard[1], cards_to_discard[2], cards_to_discard[3])
        end

        it "makes player one the attacker" do
          expect(game_state.attacker).to eq player_one
        end
      end

      context "when player one discards the play" do
       let(:cards_to_discard) {[
         cards_to_attack_with[0],
         cards_to_attack_with[1],
         cards_to_defend_with[0][:with],
         cards_to_defend_with[1][:with]
       ]}

        before do
          discard_cards(player_one, cards_to_discard)
        end

        it "puts 4 cards in the discard pile" do
          expect(game_state.discard_pile.length).to eq cards_to_discard.length
        end

        it "puts those cards in the discard pile" do
          expect(game_state.discard_pile).to include(cards_to_discard[0], cards_to_discard[1], cards_to_discard[2], cards_to_discard[3])
        end

        it "makes player two the attacker" do
          expect(game_state.attacker).to eq player_two
        end
      end
    end
  end
end
