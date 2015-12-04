require 'rails_helper'

RSpec.describe ApplyDiscardAction do
  fixtures :cards

  let(:attacking_card) { cards(:hearts_7) }
  let(:game) { Game.create!(:trump_card => attacking_card) }
  let(:initial_game_state) { GameState.base_state(game) }
  let(:discard_action) { Action.new(:kind => :discard, :active_card => attacking_card) }

  describe "#call" do
    context "when there is at least one card on the table" do
      before do
        initial_game_state.deck.move_to(initial_game_state.table, attacking_card)
      end

      it "moves the card to discard_pile" do
        game_state = ApplyDiscardAction.new(initial_game_state, discard_action).call
         expect(game_state.discard_pile.include?(attacking_card)).to be_truthy
      end

      it "moves the card off the table" do
        game_state = ApplyDiscardAction.new(initial_game_state, discard_action).call
        expect(game_state.table.include?(attacking_card)).to be_falsey
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
