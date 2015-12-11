require 'rails_helper'

RSpec.describe ApplyPickUpFromTableAction do
  fixtures :cards

  let(:game) { CreateGame.new(cards(:hearts_7)).call }
  let!(:picker_uperer) { game.players.first }
  let(:game_state) { BuildGameState.new(game).call }

  let(:card_to_pick_up) { cards(:clubs_10) }

  let(:pickup_from_table_action) { instance_double(Action) }
  before do
    allow(pickup_from_table_action).to receive(:card).and_return(card_to_pick_up)
    allow(pickup_from_table_action).to receive(:player).and_return(picker_uperer)
  end
  subject { ApplyPickUpFromTableAction.new(game_state, pickup_from_table_action).call }

  describe "#call" do
    context "when only the card to pick up is on the table" do
      before do
        move_from_deck_to_table(card_to_pick_up)
      end

      context "picker-upperer picks up the card from the table" do
        it "moves the card to their hand" do
          player_state = subject.player_state_for_player(picker_uperer)
          expect(player_state.hand).to include card_to_pick_up
        end
      end
    end

    context "when the card to pick up is on the table with other cards" do
      let(:cards_on_table) do
        [cards(:clubs_6),
         cards(:diamonds_10),
         card_to_pick_up]
      end

      before do
        fill_table_from_deck(*cards_on_table)
      end

      context "picker-upperer picks up the card from the table" do
        it "moves the card to their hand" do
          player_state = subject.player_state_for_player(picker_uperer)
          expect(player_state.hand).to include card_to_pick_up
        end

        it "leaves other cards on table" do
          expect(subject.table).to include *(cards_on_table - [card_to_pick_up])
        end

        it "does not move other cards to their hand" do
          player_state = subject.player_state_for_player(picker_uperer)
          expect(player_state.hand).to_not include *(cards_on_table - [card_to_pick_up])
        end
      end
    end

    context "when the card being picked up isn't on the table" do
      it "raises error" do
        expect{ subject }.to raise_error("Card must be on table before it is picked up")
      end
    end
  end

  def fill_table_from_deck(*cards)
    cards.each { |card| move_from_deck_to_table(card) }
  end

  def move_from_deck_to_table(card)
    game_state.deck.delete(card)
    game_state.table.push(card)
  end
end
