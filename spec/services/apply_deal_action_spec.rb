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
  end
end
