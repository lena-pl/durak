require 'rails_helper'

RSpec.describe StepsController, type: :controller do
  fixtures :cards

  describe "POST create" do
    #TODO: write step controller tests
  end

  # describe "POST create" do
  #   let(:card) { cards(:hearts_7) }
  #   let(:game) { Game.create!(trump_card: card) }
  #   let(:game_state) { BuildGameState.new(game).call }
  #   let!(:player_one) { game.players.create! }
  #   let!(:player_two) { game.players.create! }
  #
  #   context 'when the step kind is not :discard or :pick_up_from_table' do
  #     before do
  #       player_one.steps.create!(kind: :draw_from_deck, card: card)
  #     end
  #
  #     it 'does not call draw cards service' do
  #       expect_any_instance_of(DrawCards).to_not receive(:call)
  #
  #       post_create(:attack)
  #     end
  #   end
  #
  #   context 'when the step kind is :pick_up_from_table' do
  #     before do
  #       player_one.steps.create!(kind: :deal, card: cards(:hearts_6))
  #       player_one.steps.create!(kind: :attack, card: cards(:hearts_6))
  #     end
  #
  #     it 'calls build game state service exactly once' do
  #       expect_any_instance_of(BuildGameState).to receive(:call).once.and_return(game_state)
  #
  #       post_create(:pick_up_from_table, player_two)
  #     end
  #
  #     it 'calls complete turn service exactly once' do
  #       expect_any_instance_of(CompleteTurn).to receive(:call).once
  #
  #       post_create(:pick_up_from_table, player_two)
  #     end
  #   end
  #
  #   context 'when the step kind is :discard' do
  #     before do
  #       player_one.steps.create!(kind: :deal, card: cards(:hearts_6))
  #       player_two.steps.create!(kind: :deal, card: cards(:hearts_7))
  #       attack = player_one.steps.create!(kind: :attack, card: cards(:hearts_6))
  #       player_two.steps.create!(kind: :defend, card: cards(:hearts_7), in_response_to_step: attack)
  #     end
  #
  #     it 'calls build game state service exactly once' do
  #       expect_any_instance_of(BuildGameState).to receive(:call).once.and_return(game_state)
  #
  #       post_create(:discard, player_one)
  #     end
  #
  #     it 'calls complete turn service exactly once' do
  #       expect_any_instance_of(CompleteTurn).to receive(:call).once
  #
  #       post_create(:discard, player_one)
  #     end
  #   end
  # end
  #
  # def post_create(kind, player = player_one, in_response_to_step = nil)
  #   post :create, game_id: game, player_id: player, step: { kind: kind,
  #                                                           card_id: card,
  #                                                           in_response_to_step: in_response_to_step }
  # end
end
