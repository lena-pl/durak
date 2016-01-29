require 'rails_helper'
require 'test_game'

RSpec.describe BuildGameState do
  fixtures :cards

  let(:trump_card) { cards(:spades_10) }
  let(:test_game) { TestGame.new(trump_card) }
  subject(:game_state) { BuildGameState.new(test_game.game_model) }

  context "when no steps have been applied" do
    it "returns GameState with trump_card from game" do
      expect(subject.call.trump_card).to eq test_game.trump_card
    end

    it "returns GameState with all cards in deck location" do
      expect(subject.call.deck).to include(*Card.all)
    end

    it "returns GameState with players" do
      expect(subject.call.player_states).to_not be_empty
    end
  end

  context "when a step cannot be applied" do
    let(:invalid_step_class) { ApplyDealStep }
    let(:invalid_step) { instance_double(invalid_step_class) }

    before do
      allow(invalid_step_class).to receive(:new).and_return invalid_step
      expect(invalid_step).to receive(:call).and_raise BuildGameState::ApplyStepError
    end

    it "does not apply that step" do
      initial_state = BuildGameState.new(test_game.game_model).call
      step = test_game.game_model.players.create!.steps.create!(kind: :deal, card: cards(:hearts_6))
      expect(STDOUT).to receive(:puts).with(BuildGameState::ApplyStepError)

      expect(subject.call.deck.cards.count).to eq initial_state.deck.cards.count
    end
  end
end
