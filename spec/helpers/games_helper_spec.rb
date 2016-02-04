require 'rails_helper'

describe GamesHelper do
  fixtures :cards

  let(:game) { Game.create!(trump_card: cards(:hearts_6)) }
  let!(:player_one) { game.players.create! }
  let!(:player_two) { game.players.create! }
  let(:game_state) { BuildGameState.new(game).call }

  context "cards have been dealt and player one is attacker" do
    before do
      player_one.steps.create!(kind: :deal, card: cards(:hearts_8))
      player_one.steps.create!(kind: :deal, card: cards(:spades_7))

      player_two.steps.create!(kind: :deal, card: cards(:spades_8))
      player_two.steps.create!(kind: :deal, card: cards(:spades_9))
    end

    describe "#player_name" do
      it "returns player one's name" do
        assign(:game, game)

        expect(helper.player_name(player_one)).to eq "Player 1"
      end

      it "returns player two's name" do
        assign(:game, game)

        expect(helper.player_name(player_two)).to eq "Player 2"
      end
    end

    describe "#opponent" do
      it "returns the player two as the opponent to player one" do
        assign(:current_player, player_one)
        assign(:game_state, game_state)

        expect(helper.opponent).to eq game_state.defender
      end

      it "returns the player one as the opponent to player two" do
        assign(:current_player, player_two)
        assign(:game_state, game_state)

        expect(helper.opponent).to eq game_state.attacker
      end
    end
  end

  describe "#suit_colour" do
    it "returns the correct suit colour for a red card" do
      expect(helper.suit_colour("hearts")).to eq "red"
    end

    it "returns the correct suit colour for a black card" do
      expect(helper.suit_colour("spades")).to eq "black"
    end
  end

  describe "#display_rank" do
    it "returns the correct rank for a card <= 10" do
      expect(helper.display_rank(8)).to eq 8
    end

    it "returns the correct rank for a card > 10" do
      expect(helper.display_rank(11)).to eq "J"
    end
  end

  describe "#display_suit_entity" do
    it "returns the correct suit entity for a card other than diamonds" do
      expect(helper.display_suit_entity("hearts")).to eq "&hearts;"
    end

    it "returns the correct suit entity for diamond card" do
      expect(helper.display_suit_entity("diamonds")).to eq "&diams;"
    end
  end
end
