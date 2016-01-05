require 'rails_helper'

RSpec.describe StepsController, type: :controller do
  fixtures :cards

  describe "POST create" do
    let(:card) { cards(:hearts_7) }
    let(:game) { CreateGame.new.call }
    let(:game_state) { BuildGameState.new(game).call }
    let(:player_one) { game.players.first }
    let(:player_two) { game.players.second }

    context 'when the step kind is not :discard or :pick_up_from_table' do
      it 'does not call build game state service' do
        expect_any_instance_of(BuildGameState).to_not receive(:call)

        post_create(:attack)
      end

      it 'does not call draw cards service' do
        expect_any_instance_of(DrawCards).to_not receive(:call)

        post_create(:attack)
      end

      it 'redirects to show page' do
        post_create(:attack)

        expect(response).to redirect_to(game)
      end
    end

    context 'when the step kind is :pick_up_from_table' do
      before do
        player_one.steps.create!(kind: :deal, card: cards(:hearts_6))
        player_one.steps.create!(kind: :attack, card: cards(:hearts_6))
      end

      it 'calls build game state service exactly once' do
        expect_any_instance_of(BuildGameState).to receive(:call).once.and_return(game_state)

        post_create(:pick_up_from_table, player_two)
      end

      it 'calls draw cards service exactly once' do
        expect_any_instance_of(DrawCards).to receive(:call).once

        post_create(:pick_up_from_table, player_two)
      end

      it 'redirects to show page' do
        post_create(:pick_up_from_table, player_two)

        expect(response).to redirect_to(game)
      end
    end

    context 'when the step kind is :discard' do
      before do
        player_one.steps.create!(kind: :deal, card: cards(:hearts_6))
        player_one.steps.create!(kind: :attack, card: cards(:hearts_6))
      end

      it 'calls build game state service exactly once' do
        expect_any_instance_of(BuildGameState).to receive(:call).once.and_return(game_state)

        post_create(:discard, player_one)
      end

      it 'calls draw cards service exactly once' do
        expect_any_instance_of(DrawCards).to receive(:call).once

        post_create(:discard, player_one)
      end

      it 'redirects to show page' do
        post_create(:discard, player_one)

        expect(response).to redirect_to(game)
      end
    end
  end

  def post_create(kind, player = player_one)
    post :create, game_id: game, player_id: player, step: { kind: kind,
                                                            card_id: card }
  end
end
