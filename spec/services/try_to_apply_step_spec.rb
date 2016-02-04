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

          TryToApplyStep.new(player: player_one, step_kind: :attack, card: cards(:spades_7)).call
        end

        it "does not return any errors" do
          service = TryToApplyStep.new(player: player_one, step_kind: :attack, card: cards(:spades_7))

          service.call

          expect(service.errors).to be_empty
        end
      end

      context "player two attacks" do
        it "calls build game state service exactly once" do
          expect_any_instance_of(BuildGameState).to receive(:call).once.and_return(game_state)

          TryToApplyStep.new(player: player_two, step_kind: :attack, card: cards(:spades_8)).call
        end

        it "return correct errors" do
          service = TryToApplyStep.new(player: player_two, step_kind: :attack, card: cards(:spades_8))

          service.call

          expect(service.errors).to eq ["It's not your turn right now!"]
        end
      end

      context "check rules comes back false" do
        before do
          allow_any_instance_of(CheckRules).to receive(:call).and_return false
        end

        it "returns no errors for discard step" do
          service = TryToApplyStep.new(player: player_one, step_kind: :discard)

          service.call

          expect(service.errors).to be_empty
        end

        it "returns no errors for pick up from table step" do
          service = TryToApplyStep.new(player: player_one, step_kind: :pick_up_from_table, card: cards(:spades_8))

          service.call

          expect(service.errors).to be_empty
        end

        it "returns no errors for deal step" do
          service = TryToApplyStep.new(player: player_one, step_kind: :deal, card: cards(:spades_12))

          service.call

          expect(service.errors).to be_empty
        end
      end
    end
  end
end
