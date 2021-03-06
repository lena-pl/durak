require 'rails_helper'

RSpec.describe ApplyDefendStep do
  fixtures :cards

  let(:game) { Game.create!(trump_card: cards(:hearts_7)) }
  let!(:player_one) { game.players.create! }
  let!(:player_two) { game.players.create! }

  let(:game_state) { BuildGameState.new(game).call }

  let(:player_one_state) { game_state.player_state_for_player(player_one) }
  let(:player_two_state) { game_state.player_state_for_player(player_two) }

  let(:attacking_card) { cards(:spades_9) }
  let(:defending_card) { cards(:spades_10) }

  let(:attack_step) { instance_double(Step) }
  before do
    allow(attack_step).to receive(:card).and_return(attacking_card)
  end

  let(:defend_step) { instance_double(Step) }
  before do
    allow(defend_step).to receive(:player).and_return(player_one)
    allow(defend_step).to receive(:card).and_return(defending_card)
    allow(defend_step).to receive(:in_response_to_step).and_return(attack_step)
  end

  subject { ApplyDefendStep.new(game_state, defend_step).call }

  describe "#call" do
    context "when the card is not in the player's hand" do
      before do
        allow(defend_step).to receive(:player).and_return(player_one)
      end

      it "raises correct error" do
        expect{ subject }.to raise_error("Card must be in player's hand to defend with")
      end
    end

    context "when the defending card is in the player's hand" do
      before do
        allow(defend_step).to receive(:player).and_return(player_one)
        game_state.deck.delete(defending_card)
        player_one_state.hand.push(defending_card)
      end

      context "when the attacking card is not on the table" do
        it "raises correct error" do
          expect{ subject }.to raise_error("Card must be on table to defend against")
        end
      end

      context "when the attacking card is on the table" do
        before do
          game_state.deck.delete(attacking_card)
          game_state.table.push(attacking_card)
        end

        it "moves the card away from the player's hand" do
          subject
          expect(player_one_state.hand).to_not include defending_card
        end

        it "moves the card onto the table" do
          expect(subject.table).to include defending_card
        end

        context "when an attacking card has already been defended against" do
          let(:another_defending_card) { cards(:spades_10) }

          before do
            game_state.deck.delete(another_defending_card)
            game_state.table.push(another_defending_card)
          end

          it "raises correct error" do
            expect{ subject }.to raise_error("#{attacking_card} has already been defended by another card")
          end
        end
      end
    end
  end
end
