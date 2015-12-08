require 'rails_helper'

RSpec.describe ApplyDealAction do
  fixtures :cards

  let(:card) { cards(:hearts_7) }
  let(:game) { Game.create!(:trump_card => card) }
  let!(:player_one) { Player.create!(:game => game) }
  let!(:player_two) { Player.create!(:game => game) }
  let(:base_game_state) { GameState.base_state(game) }

  describe "#call" do
    context "player one draws a card from the deck" do
      let(:deal_action) { Action.new(:kind => :deal, :active_card => card, :affected_player => player_one) }

      it "moves the card to player one's hand" do
        game_state = ApplyDealAction.new(base_game_state, deal_action).call
        expect(game_state.player_hand(1).include?(card)).to be_truthy
      end
    end

    context "player two draws a card from the deck" do
      let(:deal_action) { Action.new(:kind => :deal, :active_card => card, :affected_player => player_two) }

      it "moves the card to player two's hand" do
        game_state = ApplyDealAction.new(base_game_state, deal_action).call
        expect(game_state.player_hand(2).include?(card)).to be_truthy
      end
    end

    context "when player one gets the lowest trump card" do
      let(:deal_action) { Action.new(:kind => :deal, :active_card => cards(:hearts_6), :affected_player => player_one) }

      before do
        base_game_state.deck.move_to(base_game_state.player_hand(1), cards(:spades_6))
        base_game_state.deck.move_to(base_game_state.player_hand(2), cards(:hearts_8))
      end

      it "moves the lowest trump card to player one's hand" do
        game_state = ApplyDealAction.new(base_game_state, deal_action).call
        expect(game_state.attacker).to eq player_one
      end
    end

    context "when player two gets the lowest trump card" do
      let(:deal_action) { Action.new(:kind => :deal, :active_card => cards(:hearts_6), :affected_player => player_two) }

      before do
        base_game_state.deck.move_to(base_game_state.player_hand(2), cards(:spades_6))
        base_game_state.deck.move_to(base_game_state.player_hand(1), cards(:hearts_8))
      end

      it "moves the lowest trump card to player one's hand" do
        game_state = ApplyDealAction.new(base_game_state, deal_action).call
        expect(game_state.attacker).to eq player_two
      end
    end

    context "when neither player has a trump card" do
      let(:deal_action) { Action.new(:kind => :deal, :active_card => cards(:diamonds_6), :affected_player => player_one) }

      before do
        base_game_state.deck.move_to(base_game_state.player_hand(1), cards(:spades_6))
        base_game_state.deck.move_to(base_game_state.player_hand(2), cards(:diamonds_8))
      end

      it "moves the lowest trump card to player one's hand" do
        game_state = ApplyDealAction.new(base_game_state, deal_action).call
        expect(game_state.attacker).to eq player_one
      end
    end
  end
end
