require 'rails_helper'

RSpec.describe ApplyDiscardAction do
  fixtures :cards

  let(:game) { CreateGame.new(cards(:hearts_12)).call }
  let(:attacker) { game.players.first }
  let(:defender) { game.players.second }

  let(:attacking_card) { cards(:spades_9) }
  let(:defending_card) { cards(:hearts_9) }

  let(:discard_action) { instance_double(Action) }
  before do
    allow(discard_action).to receive(:player).and_return(attacker)
    allow(discard_action).to receive(:card).and_return(attacking_card)
  end

  let(:game_state) { BuildGameState.new(game).call }
  before do
    game_state.attacker = attacker
  end
  subject { ApplyDiscardAction.new(game_state, discard_action).call }

  let(:attacker_state) { game_state.player_state_for_player(attacker) }
  let(:defender_state) { game_state.player_state_for_player(defender) }

  describe "#call" do
    context "when no cards are on the table" do
      it "raises the correct error" do
        expect { subject }.to raise_error("Card must be on table to discard")
      end
    end

    context "when only one attacking card is on the table" do
      before do
        move_from_deck_to_table(attacking_card)
      end

      it "only moves that card to the discard_pile" do
        expect(subject.discard_pile.count).to eq 1
        expect(subject.discard_pile).to include(attacking_card)
      end

      it "moves the card off the table" do
        expect(subject.table).to_not include(attacking_card)
      end

      it "only moves that card off the table" do
        expect(subject.table).to be_empty
      end
    end

    context "when the one attacking and one defending card is on the table" do
      before do
        fill_table_from_deck(attacking_card, defending_card)
      end

      context "when the attacking card is discarded" do
        before do
          allow(discard_action).to receive(:player).and_return(attacker)
          allow(discard_action).to receive(:card).and_return(attacking_card)
        end

        it "only moves that card to discard_pile" do
          expect(subject.discard_pile.count).to eq 1
          expect(subject.discard_pile).to include(attacking_card)
        end

        it "moves that card off the table" do
          expect(subject.table).to_not include(attacking_card)
        end

        it "leaves the defending card on the table" do
          expect(subject.table.count).to eq 1
          expect(subject.table).to include(defending_card)
        end
      end

      context "when the defending card is discarded" do
        before do
          allow(discard_action).to receive(:player).and_return(defender)
          allow(discard_action).to receive(:card).and_return(defending_card)
        end

        it "only moves that card to discard_pile" do
          expect(subject.discard_pile.count).to eq 1
          expect(subject.discard_pile).to include(defending_card)
        end

        it "moves that card off the table" do
          expect(subject.table).to_not include(defending_card)
        end

        it "only leaves the attacking card on the table" do
          expect(subject.table.count).to eq 1
          expect(subject.table).to include(attacking_card)
        end
      end
    end

    context do
      let(:player_one) { attacker }
      let(:player_two) { defender }

      context "when there is one card left on the table" do
        before do
          move_from_deck_to_table(attacking_card)
        end

        context "when player one is the attacker" do
          before do
            game_state.attacker = player_one
          end

          context "when player_one discards a card" do
            before do
              allow(discard_action).to receive(:player).and_return(player_one)
            end

            it "makes the player_two the new attacker" do
              expect(subject.attacker).to eq player_two
            end
          end

          context "when player_two discards a card" do
            before do
              allow(discard_action).to receive(:player).and_return(player_two)
            end

            it "keeps player_one as the attacker" do
              expect(subject.attacker).to eq player_one
            end
          end
        end

        context "when player two is the attacker" do
          before do
            game_state.attacker = player_two
          end

          context "when player_two discards a card" do
            before do
              allow(discard_action).to receive(:player).and_return(player_two)
            end

            it "makes the player_one the new attacker" do
              expect(subject.attacker).to eq player_one
            end
          end

          context "when player_one discards a card" do
            before do
              allow(discard_action).to receive(:player).and_return(player_one)
            end

            it "keeps player_two as the attacker" do
              expect(subject.attacker).to eq player_two
            end
          end
        end
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
