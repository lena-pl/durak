require 'rails_helper'

RSpec.describe TryToApplyStep do
  fixtures :cards

  let(:game) { Game.create!(trump_card: cards(:hearts_6)) }
  let!(:player_one) { game.players.create! }
  let!(:player_two) { game.players.create! }
  let(:game_state) { BuildGameState.new(game).call }

  describe "#call" do
    context "player one is the attacker" do
      before do
        player_one.steps.create!(kind: :deal, card: cards(:hearts_10))
        player_one.steps.create!(kind: :deal, card: cards(:spades_7))

        player_two.steps.create!(kind: :deal, card: cards(:spades_8))
        player_two.steps.create!(kind: :deal, card: cards(:spades_9))
      end

      context "player one attacks" do
        it "calls build game state service exactly once" do
          expect_any_instance_of(BuildGameState).to receive(:call).once.and_return(game_state)

          TryToApplyStep.new(game: game, player: player_one, step_kind: :attack, card_id: cards(:spades_7).id).call
        end

        it "does not return any errors" do
          service = TryToApplyStep.new(game: game, player: player_one, step_kind: :attack, card_id: cards(:spades_7).id)

          service.call

          expect(service.errors).to be_empty
        end
      end

      context "player two attacks" do
        it "calls build game state service exactly once" do
          expect_any_instance_of(BuildGameState).to receive(:call).once.and_return(game_state)

          TryToApplyStep.new(game: game, player: player_two, step_kind: :attack, card_id: cards(:spades_8).id).call
        end

        it "return correct errors" do
          service = TryToApplyStep.new(game: game, player: player_two, step_kind: :attack, card_id: cards(:spades_8).id)

          service.call

          expect(service.errors).to eq ["It's not your turn right now!"]
        end
      end
    end
  end
end
