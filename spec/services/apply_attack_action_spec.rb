require 'rails_helper'

RSpec.describe ApplyAttackAction do

  let(:card) { Card.create!(:rank => 7, :suit => :hearts) }
  let(:game) { Game.create!(:trump_card => card) }
  let!(:player_one) { Player.create!(:game => game) }
  let!(:player_two) { Player.create!(:game => game) }

  describe "#call" do
    context "when the card is not in player one's hand" do
      let(:card_locations) { CardLocations.new(player_one_hand: []) }
      let(:initial_game_state) { GameState.new(nil, card_locations, nil, game.players) }
      let(:attack_action) { Action.new(:kind => :attack, :active_card => card, :initiating_player => player_one) }

      subject { ApplyAttackAction.new(initial_game_state, attack_action) }

      it "raises error" do
        expect{ subject.call }.to raise_error("Card must be in player's hand to attack")
      end
    end

    context "when the card is in player one's hand" do
      let(:card_locations) { CardLocations.new(player_one_hand: [card]) }
      let(:initial_game_state) { GameState.new(nil, card_locations, nil, game.players) }
      let(:attack_action) { Action.new(:kind => :attack, :active_card => card, :initiating_player => player_one) }

      it "moves the card to the table" do
        game_state = ApplyAttackAction.new(initial_game_state, attack_action).call
        expect(game_state.card_locations.at(:table)).to eq [card]
      end
    end

    context "when the card is not in player two's hand" do
      let(:card_locations) { CardLocations.new(player_two_hand: []) }
      let(:initial_game_state) { GameState.new(nil, card_locations, nil, game.players) }
      let(:attack_action) { Action.new(:kind => :attack, :active_card => card, :initiating_player => player_two) }

      subject { ApplyAttackAction.new(initial_game_state, attack_action) }

      it "raises error" do
        expect{ subject.call }.to raise_error("Card must be in player's hand to attack")
      end
    end

    context "when the card is in player two's hand" do
      let(:card_locations) { CardLocations.new(player_two_hand: [card]) }
      let(:initial_game_state) { GameState.new(nil, card_locations, nil, game.players) }
      let(:attack_action) { Action.new(:kind => :attack, :active_card => card, :initiating_player => player_two) }

      it "moves the card to the table" do
        game_state = ApplyAttackAction.new(initial_game_state, attack_action).call
        expect(game_state.card_locations.at(:table)).to eq [card]
      end
    end
  end
end
