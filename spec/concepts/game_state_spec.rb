require 'rails_helper'

RSpec.describe GameState do
  fixtures :cards

  let(:game) { CreateGame.new(cards(:hearts_7)).call }
  let!(:player_one) { game.players.first }
  let!(:player_two) { game.players.second }

  subject(:game_state) { BuildGameState.new(game).call }

  describe "#player_state_for_player" do
    it "returns player one state for player one" do
      expect(game_state.player_state_for_player(player_one)).to eq game_state.player_states.first
    end

    it "returns player two state for player two" do
      expect(game_state.player_state_for_player(player_two)).to eq game_state.player_states.second
    end
  end

  describe "#current_player" do
    context "when the attacker is not set" do
      before do
        game_state.attacker = nil
      end

      it "returns nil" do
        expect(game_state.current_player).to be_nil
      end
    end

    context "when player one is the attacker" do
      before do
        game_state.attacker = player_one
      end

      context "there are no cards on the table" do
        before do
          game_state.table.clear
        end

        it "returns the attacker" do
          expect(game_state.current_player).to eq player_one
        end
      end

      context "when is one attack defend pair on the table" do
        context "when only the attacking card is in the pair" do
          before do
            game_state.table.push(cards(:hearts_12))
          end

          it "returns the defender" do
            expect(game_state.current_player).to eq player_two
          end
        end

        context "when both cards are in the pair" do
          before do
            game_state.table.push(cards(:hearts_12))
            game_state.table.push(cards(:hearts_14))
          end

          it "returns the attacker" do
            expect(game_state.current_player).to eq player_one
          end
        end
      end
    end
  end

  describe "#defender" do
    context "when player one is the attacker" do
      before do
        game_state.attacker = player_one
      end

      it "returns player two" do
        expect(game_state.defender).to eq player_two
      end
    end

    context "when player two is the attacker" do
      before do
        game_state.attacker = player_two
      end

      it "returns player one" do
        expect(game_state.defender).to eq player_one
      end
    end
  end

  context "when the deck and table are empty and both players each have 1 card left" do
    before do
      game_state.deck.delete(cards(:hearts_6))
      game_state.player_state_for_player(player_one).hand.push(cards(:hearts_6))

      game_state.deck.delete(cards(:hearts_8))
      game_state.player_state_for_player(player_two).hand.push(cards(:hearts_8))

      game_state.deck.clear
      game_state.table.clear
    end

    describe "#over?" do
      it "returns false" do
        expect(game_state).to_not be_over
      end
    end

    describe "#draw?" do
      it "returns false" do
        expect(game_state).to_not be_draw
      end
    end

    describe "#durak" do
      it "returns nil" do
        expect(game_state.durak).to be_nil
      end
    end

    describe "#winner" do
      it "returns nil" do
        expect(game_state.winner).to be_nil
      end
    end
  end

  context "when the deck and table are empty and only player one has a card left" do
    before do
      game_state.deck.delete(cards(:hearts_6))
      game_state.player_state_for_player(player_one).hand.push(cards(:hearts_6))

      game_state.deck.clear
      game_state.table.clear
    end

    describe "#over?" do
      it "returns true" do
        expect(game_state).to be_over
      end
    end

    describe "#draw?" do
      it "returns false" do
        expect(game_state).to_not be_draw
      end
    end

    describe "#durak" do
      it "returns player_one" do
        expect(game_state.durak).to eq player_one
      end
    end

    describe "#winner" do
      it "returns player_two" do
        expect(game_state.winner).to eq player_two
      end
    end
  end

  context "when the deck and table are empty and both have no cards" do
    before do
      game_state.deck.clear
      game_state.table.clear
    end

    describe "#over?" do
      it "returns true" do
        expect(game_state).to be_over
      end
    end

    describe "#draw?" do
      it "returns true" do
        expect(game_state).to be_draw
      end
    end

    describe "#durak" do
      it "returns nil" do
        expect(game_state.durak).to be_nil
      end
    end

    describe "#winner" do
      it "returns nil" do
        expect(game_state.winner).to be_nil
      end
    end
  end

  context "when the deck is empty and there are 2 cards on the table and both players' hands are empty" do
    before do
      game_state.table.push(cards(:diamonds_7))
      game_state.table.push(cards(:diamonds_8))

      game_state.deck.clear
    end

    describe "#over?" do
      it "returns false" do
        expect(game_state).to_not be_over
      end
    end

    describe "#draw?" do
      it "returns false" do
        expect(game_state).to_not be_draw
      end
    end

    describe "#durak" do
      it "returns nil" do
        expect(game_state.durak).to be_nil
      end
    end

    describe "#winner" do
      it "returns nil" do
        expect(game_state.winner).to be_nil
      end
    end
  end

  context "when there are still cards in the deck" do
    describe "#over?" do
      it "returns false" do
        expect(game_state).to_not be_over
      end
    end

    describe "#draw?" do
      it "returns false" do
        expect(game_state).to_not be_draw
      end
    end

    describe "#durak" do
      it "returns nil" do
        expect(game_state.durak).to be_nil
      end
    end

    describe "#winner" do
      it "returns nil" do
        expect(game_state.winner).to be_nil
      end
    end
  end
end
