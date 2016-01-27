require 'rails_helper'

RSpec.describe EndTurn do
  fixtures :cards

  let(:game) { Game.create!(trump_card: cards(:hearts_6)) }
  let!(:player_one) { game.players.create! }
  let!(:player_two) { game.players.create! }

  describe "#call" do
    context "player one is the attacker" do
      before do
        player_one.steps.create!(kind: :deal, card: cards(:hearts_10))
        player_one.steps.create!(kind: :deal, card: cards(:spades_7))

        player_two.steps.create!(kind: :deal, card: cards(:spades_8))
        player_two.steps.create!(kind: :deal, card: cards(:spades_9))
      end

      context "player one discards" do
        before do
          player_one.steps.create!(kind: :attack, card: cards(:spades_7))
          player_two.steps.create!(kind: :defend, card: cards(:spades_8), in_response_to_step: game.steps.last)
        end

        it "calls try to apply step service exactly once" do
          expect_any_instance_of(TryToApplyStep).to receive(:call).once

          EndTurn.new(player_one, game).call
        end

        it "does not return any errors" do
          service = EndTurn.new(player_one, game)

          service.call

          expect(service.errors).to be_empty
        end

        it "passes the correct arguments to try to apply step" do
          apply = instance_double(TryToApplyStep)

          expect(TryToApplyStep).to receive(:new).with(game: game, player: player_one, step_kind: :discard).and_return(apply)

          expect(apply).to receive(:call)
          allow(apply).to receive(:errors).and_return([])

          EndTurn.new(player_one, game).call
        end
      end

      context "player two picks up" do
        before do
          player_one.steps.create!(kind: :attack, card: cards(:spades_7))
        end

        it "calls try to apply step service exactly once" do
          expect_any_instance_of(TryToApplyStep).to receive(:call).once

          EndTurn.new(player_two, game).call
        end

        it "does not return any errors" do
          service = EndTurn.new(player_two, game)

          service.call

          expect(service.errors).to be_empty
        end

        it "passes the correct arguments to try to apply step" do
          apply = instance_double(TryToApplyStep)

          expect(TryToApplyStep).to receive(:new).with(game: game, player: player_two, step_kind: :pick_up_from_table).and_return(apply)

          expect(apply).to receive(:call)
          allow(apply).to receive(:errors).and_return([])

          EndTurn.new(player_two, game).call
        end
      end
    end
  end
end
