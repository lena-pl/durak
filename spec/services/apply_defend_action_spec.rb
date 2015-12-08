require 'rails_helper'

RSpec.describe ApplyDefendAction do
  fixtures :cards

  let(:trump_card) { cards(:hearts_7) }
  let(:game) { Game.create!(:trump_card => trump_card) }
  let!(:player_one) { Player.create!(:game => game) }
  let!(:player_two) { Player.create!(:game => game) }
  let(:initial_game_state) { GameState.base_state(game) }

  let(:card) { cards(:spades_10) }
  let(:passive_card) { cards(:spades_7) }

  describe "#call" do
    context "when the card is not in player one's hand" do
      let(:defend_action) { Action.new(:kind => :defend, :active_card => card, :passive_card => passive_card, :player => player_one) }

      subject { ApplyDefendAction.new(initial_game_state, defend_action) }

      it "raises error" do
        expect{ subject.call }.to raise_error("Card must be in player's hand to defend with")
      end
    end

    context "when the card is not in player two's hand" do
      let(:defend_action) { Action.new(:kind => :defend, :active_card => card, :passive_card => passive_card, :player => player_two) }

      subject { ApplyDefendAction.new(initial_game_state, defend_action) }

      it "raises error" do
        expect{ subject.call }.to raise_error("Card must be in player's hand to defend with")
      end
    end

    context "when the attacking card is not on the table hand" do
      let(:defend_action) { Action.new(:kind => :defend, :active_card => card, :passive_card => passive_card, :player => player_one) }

      subject { ApplyDefendAction.new(initial_game_state, defend_action) }

      before do
        initial_game_state.deck.delete(card)
        initial_game_state.player_hand(1).add(card)
      end

      it "raises error" do
        expect{ subject.call }.to raise_error("Card must be on table to defend against")
      end
    end

    context "when the attacking card is on the table hand and defending card is in player one's hand" do

      let(:defend_action) { Action.new(:kind => :defend, :active_card => card, :passive_card => passive_card, :player => player_one) }

      subject { ApplyDefendAction.new(initial_game_state, defend_action) }

      before do
        initial_game_state.deck.move_to(initial_game_state.player_hand(1), card)
        initial_game_state.deck.move_to(initial_game_state.table, passive_card)
      end

      it "moves the card away from player one's hand" do
        game_state = ApplyDefendAction.new(initial_game_state, defend_action).call
        expect(game_state.player_hand(1)).to_not include card
      end

      it "moves the card to the table" do
        game_state = ApplyDefendAction.new(initial_game_state, defend_action).call
        expect(game_state.table).to include card
      end
    end

    context "when the attacking card is on the table hand and defending card is in player two's hand" do

      let(:defend_action) { Action.new(:kind => :defend, :active_card => card, :passive_card => passive_card, :player => player_two) }

      subject { ApplyDefendAction.new(initial_game_state, defend_action) }

      before do
        initial_game_state.deck.move_to(initial_game_state.player_hand(2), card)
        initial_game_state.deck.move_to(initial_game_state.table, passive_card)
      end

      it "moves the card away from player two's hand" do
        game_state = ApplyDefendAction.new(initial_game_state, defend_action).call
        expect(game_state.player_hand(2)).to_not include card
      end

      it "moves the card to the table" do
        game_state = ApplyDefendAction.new(initial_game_state, defend_action).call
        expect(game_state.table).to include card
      end
    end
  end
end
