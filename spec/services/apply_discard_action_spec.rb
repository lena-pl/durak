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
    context "when only one attacking card is on the table" do
      before do
        move_from_deck_to_table(attacking_card)
      end

      it "moves that card to discard_pile" do
        expect(subject.discard_pile).to include(attacking_card)
      end

      it "only move that card to the discard_pile" do
        expect(subject.discard_pile.count).to eq 1
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

    context "when the attacker has discarded a card" do
      before do
        move_from_deck_to_table(attacking_card)
      end

      it "makes the current defender the new attacker" do
        expect(subject.attacker).to eq defender
      end
    end

    context "when the defender has discarded a card" do
      before do
        allow(discard_action).to receive(:player).and_return(defender)
        move_from_deck_to_table(attacking_card)
      end

      it "makes the attacker the new attacker" do
        expect(subject.attacker).to eq attacker
      end
    end

   #   context "when player one is the attacker" do
   #     let(:discard_action) { Action.new(:kind => :discard, :card => attacking_card, :player => player_one) }

   #     before do
   #       initial_game_state.attacker = player_one
   #     end

   #     it "changes the attacker to player two" do
   #       game_state = ApplyDiscardAction.new(initial_game_state, discard_action).call
   #       expect(game_state.attacker).to eq player_two
   #     end
   #   end

   #   context "when player two is the attacker" do
   #     let(:discard_action) { Action.new(:kind => :discard, :card => attacking_card, :player => player_two) }

   #     before do
   #       initial_game_state.attacker = player_two
   #     end

   #     it "changes the attacker to player one" do
   #       game_state = ApplyDiscardAction.new(initial_game_state, discard_action).call
   #       expect(game_state.attacker).to eq player_one
   #     end
   #   end

   #   context "when two discard actions are made by the same attacker" do
   #     let(:another_discard_action) { Action.new(:kind => :discard, :card => defending_card, :player => player_two) }

   #     before do
   #       initial_game_state.attacker = player_two
   #     end

   #     it "changes the attacker to player one" do
   #       game_state = ApplyDiscardAction.new(initial_game_state, discard_action).call
   #       game_state = ApplyDiscardAction.new(initial_game_state, another_discard_action).call

   #       expect(game_state.attacker).to eq player_one
   #     end
   #   end
   # end

   # context "when there are no cards on the table" do
   #   subject { ApplyDiscardAction.new(initial_game_state, discard_action) }

   #   it "raises error" do
   #     expect{ subject.call }.to raise_error("Card must be on table to discard")
   #   end
   # end
  end

  def fill_table_from_deck(*cards)
    cards.each { |card| move_from_deck_to_table(card) }
  end

  def move_from_deck_to_table(card)
    game_state.deck.delete(card)
    game_state.table.push(card)
  end
end
