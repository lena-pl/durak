require 'rails_helper'

RSpec.describe ApplyDefendAction do
  fixtures :cards

  let(:trump_card) { cards(:hearts_7) }
  let(:game) { Game.create!(:trump_card => trump_card) }
  let!(:player_one) { Player.create!(:game => game) }
  let!(:player_two) { Player.create!(:game => game) }
  let(:game_state) { BuildGameState.base_state(game) }

  let(:attacking_card) { cards(:spades_9) }
  let(:defending_card) { cards(:spades_10) }

  let(:attack_action) { instance_double(Action) }
  before do
    allow(attack_action).to receive(:card).and_return(attacking_card)
  end

  let(:defend_action) { instance_double(Action) }
  before do
    allow(defend_action).to receive(:card).and_return(defending_card)
    allow(defend_action).to receive(:in_response_to_action).and_return(attack_action)
  end

  subject { ApplyDefendAction.new(game_state, defend_action) }

  describe "#call" do
    context "when the card is not in player one's hand" do
      before do
        allow(defend_action).to receive(:player).and_return(player_one)
      end

      it "raises correct error" do
        expect{ subject.call }.to raise_error("Card must be in player's hand to defend with")
      end
    end

    context "when the card is not in player two's hand" do
      before do
        allow(defend_action).to receive(:player).and_return(player_two)
      end

      it "raises correct error" do
        expect{ subject.call }.to raise_error("Card must be in player's hand to defend with")
      end
    end

    context "when the defending card is in player one's hand" do
      before do
        allow(defend_action).to receive(:player).and_return(player_one)
        game_state.deck.move_to(game_state.player_hand(1), defending_card)
      end

      context "when the attacking card is not on the table" do
        it "raises correct error" do
          expect{ subject.call }.to raise_error("Card must be on table to defend against")
        end
      end

      context "when the attacking card is on the table" do
        before do
          game_state.deck.move_to(game_state.table, attacking_card)
        end

        it "moves the card away from player one's hand" do
          expect(subject.call.player_hand(1)).to_not include defending_card
        end

        it "moves the card onto the table" do
          expect(subject.call.table).to include defending_card
        end

        context "when an attacking action has already been defended against" do
          before do
            first_defending_card = cards(:clubs_13)
            game_state.deck.move_to(game_state.table, first_defending_card)
          end

          it "raises correct error" do
            expect{ subject.call }.to raise_error("#{attacking_card} has already been defended by another card")
          end
        end
      end
    end

    context "when the defending card is in player two's hand" do
      before do
        allow(defend_action).to receive(:player).and_return(player_two)
        game_state.deck.move_to(game_state.player_hand(2), defending_card)
      end

      context "when the attacking card is not on the table" do
        it "raises correct error" do
          expect{ subject.call }.to raise_error("Card must be on table to defend against")
        end
      end

      context "when the attacking card is on the table" do
        before do
          game_state.deck.move_to(game_state.table, attacking_card)
        end

        it "moves the card away from player two's hand" do
          expect(subject.call.player_hand(2)).to_not include defending_card
        end

        it "moves the card onto the table" do
          expect(subject.call.table).to include defending_card
        end

        context "when an attacking action has already been defended against" do
          before do
            first_defending_card = cards(:clubs_13)
            game_state.deck.move_to(game_state.table, first_defending_card)
          end

          it "raises correct error" do
            expect{ subject.call }.to raise_error("#{attacking_card} has already been defended by another card")
          end
        end
      end
    end

  end
end
