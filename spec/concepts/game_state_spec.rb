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

    describe "#durak_found?" do
      it "returns false" do
        expect(game_state.durak_found?).to eq false
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

    describe "#durak_found?" do
      it "returns true" do
        expect(game_state.durak_found?).to eq true
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

    describe "#durak_found?" do
      it "returns false" do
        expect(game_state.durak_found?).to eq false
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

    describe "#durak_found?" do
      it "returns false" do
        expect(game_state.durak_found?).to eq false
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

    describe "#durak_found?" do
      it "returns false" do
        expect(game_state.durak_found?).to eq false
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
