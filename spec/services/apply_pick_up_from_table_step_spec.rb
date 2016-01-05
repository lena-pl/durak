require 'rails_helper'

RSpec.describe ApplyPickUpFromTableStep do
  fixtures :cards

  let(:game) { CreateGame.new(cards(:hearts_7)).call }
  let!(:attacker) { game.players.first }
  let!(:defender) { game.players.second }

  let(:pick_up_from_table_step) { instance_double(Step) }
  before do
    allow(pick_up_from_table_step).to receive(:player).and_return(defender)
  end

  let(:game_state) { BuildGameState.new(game).call }
  before do
    game_state.attacker = attacker
  end

  subject { ApplyPickUpFromTableStep.new(game_state, pick_up_from_table_step).call }

  describe "#call" do
    context "when the attacker tries to pick up cards" do
      before do
        allow(pick_up_from_table_step).to receive(:player).and_return(attacker)
      end

      it "raises the correct error" do
        expect { subject }.to raise_error("Only the defender can pick up cards from the table")
      end
    end

    context "when the table is empty" do
      before do
        game_state.table.clear
      end

      it "raises the correct error" do
        expect { subject }.to raise_error("Must be at least one card on the table to pickup")
      end
    end

    context "when there are cards on the table" do
      let(:cards_on_table) do
        [cards(:clubs_6),
         cards(:clubs_10),
         cards(:hearts_14)]
      end

      before do
        game_state.table.push(*cards_on_table)
      end

      context "defender picks up from the table" do
        it "puts cards on the table in their hand" do
          player_state = subject.player_state_for_player(defender)
          expect(player_state.hand).to include(*cards_on_table)
        end

        it "moves the cards off the table" do
          expect(subject.table).to be_empty
        end
      end
    end
  end
end
