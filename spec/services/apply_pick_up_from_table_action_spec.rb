require 'rails_helper'

RSpec.describe ApplyPickUpFromTableAction do
  fixtures :cards

  let(:card) { cards(:hearts_7) }
  let(:game) { Game.create!(:trump_card => card) }
  let!(:player_one) { Player.create(:game => game) }
  let!(:player_two) { Player.create(:game => game) }
  let(:initial_game_state) { BuildGameState.base_state(game) }

  describe "#call" do
    context "when there is at least one card on the table" do

      context "player one picks up a card from the table" do
        let(:pickup_from_table_action) { Action.new(:kind => :pick_up_from_table, :card => card, :player => player_one) }

        before do
          initial_game_state.deck.move_to(initial_game_state.table, card)
        end

        it "moves the card to player one's hand" do
          game_state = ApplyPickUpFromTableAction.new(initial_game_state, pickup_from_table_action).call
          expect(game_state.player_hand(1)).to include card
        end
      end

      context "player two picks up a card from the table" do
        let(:pickup_from_table_action) { Action.new(:kind => :pick_up_from_table, :card => card, :player => player_two) }

        before do
          initial_game_state.deck.move_to(initial_game_state.table, card)
        end

        it "moves the card to player two's hand" do
          game_state = ApplyPickUpFromTableAction.new(initial_game_state, pickup_from_table_action).call
          expect(game_state.player_hand(2)).to include card
        end
      end
    end

    context "when the card being picked up isn't on the table" do
      let(:pickup_from_table_action) { Action.new(:kind => :pick_up_from_table, :card => card, :player => player_one) }

      subject { ApplyPickUpFromTableAction.new(initial_game_state, pickup_from_table_action) }

      it "raises error" do
        expect{ subject.call }.to raise_error("Card must be on table before it is picked up")
      end
    end
  end
end
