require 'rails_helper'

RSpec.describe ConnectPlayer do
  fixtures :cards

  let(:game) { Game.create!(trump_card: cards(:hearts_6)) }
  let!(:player_one) { game.players.create! }
  let!(:player_two) { game.players.create! }
  let(:session) { {} }
  subject { ConnectPlayer.new(game, session).call }

  describe "#call" do
    context "when the game is not full" do
      before do
        game.players.first.update_attributes!(connected: true)
      end

      it 'returns ok' do
        expect(subject).to eq :ok
      end
    end

    context "when the game is full" do
      before do
        game.players.first.update_attributes!(connected: true)
        game.players.second.update_attributes!(connected: true)
      end

      it 'returns full' do
        expect(subject).to eq :full
      end
    end
  end
end
