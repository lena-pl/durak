require 'rails_helper'

RSpec.describe ApplyDiscardAction do

  let(:card) { Card.create!(:rank => 7, :suit => :hearts) }
  let(:game) { Game.create!(:trump_card => card) }

  describe "#call" do
    context "when there is at least one card on the table" do
      let(:card_locations) { CardLocations.new(table: [card]) }
      let(:initial_game_state) { GameState.new(nil, card_locations, nil, nil) }
      let(:discard_action) { Action.new(:kind => :discard, :active_card => card) }

      it "moves the card to discard_pile" do
        game_state = ApplyDiscardAction.new(initial_game_state, discard_action).call
        expect(game_state.card_locations.at(:discard_pile)).to eq [card]
      end
    end

    context "when there are no cards on the table" do
      let(:card_locations) { CardLocations.new(table: []) }
      let(:initial_game_state) { GameState.new(nil, card_locations, nil, nil) }
      let(:discard_action) { Action.new(:kind => :discard, :active_card => card) }

      subject { ApplyDiscardAction.new(initial_game_state, discard_action) }

      it "raises error" do
        expect{ subject.call }.to raise_error("Card must be on table to discard")
      end
    end
  end
end
