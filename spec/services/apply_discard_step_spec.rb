require 'rails_helper'

RSpec.describe ApplyDiscardStep do
  fixtures :cards

  let(:game) { CreateGame.new(cards(:hearts_12)).call }
  let(:attacker) { game.players.first }
  let(:defender) { game.players.second }

  let(:attacking_card) { cards(:spades_9) }
  let(:defending_card) { cards(:hearts_9) }

  let(:discard_step) { instance_double(Step) }
  before do
    allow(discard_step).to receive(:player).and_return(attacker)
  end

  let(:game_state) { BuildGameState.new(game).call }
  before do
    game_state.attacker = attacker
  end

  subject { ApplyDiscardStep.new(game_state, discard_step).call }

  let(:attacker_state) { game_state.player_state_for_player(attacker) }
  let(:defender_state) { game_state.player_state_for_player(defender) }

  describe "#call" do
    context "when the defender tries to discard cards" do
      before do
        allow(discard_step).to receive(:player).and_return(defender)
      end

      it "raises the correct error" do
        expect { subject }.to raise_error("Only the attacker can discard cards from the table")
      end
    end

    context "when the table is empty" do
      before do
        game_state.table.clear
      end

      it "raises the correct error" do
        expect { subject }.to raise_error("Must be at least one card on the table to discard")
      end
    end

    context "when there are some cards on the table" do
      before do
        game_state.table.push(attacking_card, defending_card)
      end

      it "puts all the cards in the discard pile" do
        expect(subject.discard_pile.count).to eq 2
        expect(subject.discard_pile).to include(attacking_card, defending_card)
      end

      it "moves the cards off the table" do
        expect(subject.table).to be_empty
      end

      context do
        let(:player_one) { attacker }
        let(:player_two) { defender }

        context "when player one is the attacker" do
          before do
            game_state.attacker = player_one
            allow(discard_step).to receive(:player).and_return(player_one)
          end

          it "makes the player_two the new attacker" do
            expect(subject.attacker).to eq player_two
          end
        end

        context "when player two is the attacker" do
          before do
            game_state.attacker = player_two
            allow(discard_step).to receive(:player).and_return(player_two)
          end

          it "makes the player_one the new attacker" do
            expect(subject.attacker).to eq player_one
          end
        end
      end
    end
  end
end
