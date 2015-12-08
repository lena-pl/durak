require 'rails_helper'

RSpec.describe ApplyDiscardAction do
  fixtures :cards

  let(:attacking_card) { cards(:hearts_7) }
  let(:defending_card) { cards(:hearts_9) }
  let(:game) { Game.create!(:trump_card => attacking_card) }
  let!(:player_one) { Player.create!(:game => game) }
  let!(:player_two) { Player.create!(:game => game) }
  let(:initial_game_state) { GameState.base_state(game) }
  let(:discard_action) { Action.new(:kind => :discard, :active_card => attacking_card) }

  describe "#call" do
    context "when only one attacking card is on the table" do
      before do
        initial_game_state.deck.move_to(initial_game_state.table, attacking_card)
      end

      it "moves the card to discard_pile" do
        game_state = ApplyDiscardAction.new(initial_game_state, discard_action).call
        expect(game_state.discard_pile).to include(attacking_card)
      end

      it "moves the card off the table" do
        game_state = ApplyDiscardAction.new(initial_game_state, discard_action).call
        expect(game_state.table).to_not include(attacking_card)
      end
    end

    context "when two cards are on the table" do
      let(:another_discard_action) { Action.new(:kind => :discard, :active_card => defending_card) }

      before do
        initial_game_state.deck.move_to(initial_game_state.table, attacking_card)
        initial_game_state.deck.move_to(initial_game_state.table, defending_card)
      end

      it "moves both cards to the discard pile" do
        game_state = ApplyDiscardAction.new(initial_game_state, discard_action).call
        game_state = ApplyDiscardAction.new(initial_game_state, another_discard_action).call

        expect(game_state.discard_pile).to include(attacking_card, defending_card)
      end

      it "moves the cards off the table" do
        game_state = ApplyDiscardAction.new(initial_game_state, discard_action).call
        game_state = ApplyDiscardAction.new(initial_game_state, another_discard_action).call

        expect(game_state.table).to_not include(attacking_card, defending_card)
      end

      context "when player one is the attacker" do
        let(:discard_action) { Action.new(:kind => :discard, :active_card => attacking_card, :initiating_player => player_one) }

        before do
          initial_game_state.attacker = player_one
        end

        it "changes the attacker to player two" do
          game_state = ApplyDiscardAction.new(initial_game_state, discard_action).call
          expect(game_state.attacker).to eq player_two
        end
      end

      context "when player two is the attacker" do
        let(:discard_action) { Action.new(:kind => :discard, :active_card => attacking_card, :initiating_player => player_two) }

        before do
          initial_game_state.attacker = player_two
        end

        it "changes the attacker to player one" do
          game_state = ApplyDiscardAction.new(initial_game_state, discard_action).call
          expect(game_state.attacker).to eq player_one
        end
      end

      context "when two discard actions are made by the same attacker" do
        let(:another_discard_action) { Action.new(:kind => :discard, :active_card => defending_card, :initiating_player => player_two) }

        before do
          initial_game_state.attacker = player_two
        end

        it "changes the attacker to player one" do
          game_state = ApplyDiscardAction.new(initial_game_state, discard_action).call
          game_state = ApplyDiscardAction.new(initial_game_state, another_discard_action).call

          expect(game_state.attacker).to eq player_one
        end
      end
    end

    context "when there are no cards on the table" do
      subject { ApplyDiscardAction.new(initial_game_state, discard_action) }

      it "raises error" do
        expect{ subject.call }.to raise_error("Card must be on table to discard")
      end
    end
  end
end
