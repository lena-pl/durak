require 'rails_helper'
require 'test_game'

RSpec.describe BuildGameState do
  fixtures :cards

  let(:player_one_initial_hand) do
    [cards(:diamonds_7),
     cards(:spades_9),
     cards(:diamonds_10),
     cards(:hearts_8),
     cards(:spades_7),
     cards(:hearts_12)]
  end

  let(:player_two_initial_hand) do
    [cards(:diamonds_8),
     cards(:hearts_6),
     cards(:diamonds_11),
     cards(:spades_11),
     cards(:spades_14),
     cards(:hearts_10)]
  end

  let(:deal_cards) do
    lambda do |test_game|
      player_one_initial_hand.each do |card|
        test_game.deal_card(test_game.game_model.players.first, card)
      end

      player_two_initial_hand.each do |card|
        test_game.deal_card(test_game.game_model.players.second, card)
      end
    end
  end

  let(:trump_card) { cards(:spades_10) }
  let(:test_game) { TestGame.new(trump_card) }
  subject(:game_state) { BuildGameState.new(test_game.game_model).call }

  context "when no actions have been applied" do
    it "returns GameState with trump_card from game" do
      expect(subject.trump_card).to eq test_game.trump_card
    end

    it "returns GameState with all cards in deck location" do
      expect(subject.deck).to include(*Card.all)
    end

    it "returns GameState with nil attacker" do
      expect(subject.attacker).to be_nil
    end

    it "returns GameState with players" do
      expect(subject.player_states).to_not be_empty
    end
  end

  # TODO: integration tests for GameState
  # context "when player one is the dealer and cards have been dealt" do
  #   before do
  #     test_game.apply_actions(&deal_cards)
  #   end
  #
  #   it "returns a game state with the correct cards in player one's hand" do
  #     player_one_initial_hand.each do |card|
  #       expect(subject.player_hand(1).all).to include card
  #     end
  #   end
  #
  #   it "returns a game state with the correct cards in player two's hand" do
  #     player_two_initial_hand.each do |card|
  #       expect(subject.player_hand(2).all).to include card
  #     end
  #   end
  # end
end
