require 'rails_helper'

RSpec.describe CompleteTurn do
  fixtures :cards

  let(:game) { Game.create!(trump_card: cards(:hearts_6)) }
  let!(:player_one) { game.players.create! }
  let!(:player_two) { game.players.create! }
  let(:game_state) { BuildGameState.new(game).call }

  describe "#call" do
    before do
      player_one.steps.create!(kind: :deal, card: cards(:hearts_7))
      player_one.steps.create!(kind: :deal, card: cards(:spades_7))

      player_two.steps.create!(kind: :deal, card: cards(:spades_8))
      player_two.steps.create!(kind: :deal, card: cards(:spades_9))

      player_one.steps.create!(kind: :attack, card: cards(:spades_7))
      player_two.steps.create!(kind: :defend, card: cards(:spades_8), in_response_to_step: game.steps.last)
    end

    it "draws cards when the step kind was discard" do
      expect_any_instance_of(DrawCards).to receive(:call)

      CompleteTurn.new(player_one.steps.create!(kind: :discard), game_state).call
    end

    it "does not draw cards when the step kind was attack" do
      expect_any_instance_of(DrawCards).to_not receive(:call)

      CompleteTurn.new(player_one.steps.create!(kind: :attack, card: cards(:hearts_7)), game_state).call
    end
  end
end
