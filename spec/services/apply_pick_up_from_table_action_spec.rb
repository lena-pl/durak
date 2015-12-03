require 'rails_helper'

RSpec.describe ApplyPickUpFromTableAction do
  let(:card) { Card.create!(:rank => 7, :suit => :hearts) }
  let(:game) { Game.create!(:trump_card => card) }
  let(:player_one) { Player.create(:game => game) }
  let(:player_two) { Player.create(:game => game) }

  let(:initial_game_state) { GameState.new(nil, card_locations, nil, [player_one, player_two]) }

  describe "#call" do
    context "when there is at least one card on the table" do
      let(:card_locations) { CardLocations.new(table: [card]) }

      context "player one picks up a card from the table" do
        let(:pickup_from_table_action) { Action.new(:kind => :pick_up_from_table, :active_card => card, :initiating_player => player_one) }

        it "moves the card to player one's hand" do
          game_state = ApplyPickUpFromTableAction.new(initial_game_state, pickup_from_table_action).call
          expect(game_state.card_locations.at(:player_one_hand)).to eq [card]
        end
      end

      context "player two draws a card from the deck" do
        let(:pickup_from_table_action) { Action.new(:kind => :pick_up_from_table, :active_card => card, :initiating_player => player_two) }

        it "moves the card to player two's hand" do
          game_state = ApplyPickUpFromTableAction.new(initial_game_state, pickup_from_table_action).call
          expect(game_state.card_locations.at(:player_two_hand)).to eq [card]
        end
      end
    end

    context "when the card being picked up isn't on the table" do
      let(:card_locations) { CardLocations.new(table: []) }
      let(:pickup_from_table_action) { Action.new(:kind => :pick_up_from_table, :active_card => card, :initiating_player => player_one) }

      subject { ApplyPickUpFromTableAction.new(initial_game_state, pickup_from_table_action) }

      it "raises error" do
        expect{ subject.call }.to raise_error("Card must be on table before it is picked up")
      end
    end
  end
end
