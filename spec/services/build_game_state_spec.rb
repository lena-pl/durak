require 'rails_helper'

RSpec.describe BuildGameState do
  let(:card) { Card.create!(:id => 1, :suit => :hearts) }
  let(:game) { Game.create!(:id => 1, :trump_card => card) }
  let(:player1) { Player.create!(:id => 1, :game => game) }
  let(:player2) { Player.create!(:id => 2, :game => game) }

  describe "#call" do
    it "passes in the trump suit as a param" do
      BuildGameState.new(game).call

      expect(BuildGameState).to receive(:trump_suit).with("hearts")
    end

    context "the users have drawn some cards from the deck" do
      before do
        create_action(:draw_new_card, game.players.first, Cards.find(12))
      end

      it "passes in the cards currently in the deck as a param" do
        BuildGameState.new(game).call

        expect(BuildGameState).to receive(:cards_in_deck).with("hearts")
      end
    end
  end

  def create_action(kind, player, active, passive = null)
    action = Action.create!(:kind => kind, :game => game, :player => player, :active_card => active, :passive_card => passive)
    @actions.push(action)
  end
end
