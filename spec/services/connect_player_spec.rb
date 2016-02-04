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
        player_one.update_attributes!(token: SecureRandom.hex)
      end

      it 'returns ok' do
        expect(subject).to eq :ok
      end

      context "the link is clicked by the game owner" do
        let(:session) { {"player_token" => player_one.token} }

        it 'returns game_owner' do
          expect(subject).to eq :game_owner
        end
      end
    end

    context "when the game is full" do
      before do
        player_one.update_attributes!(token: SecureRandom.hex)
        player_two.update_attributes!(token: SecureRandom.hex)
      end

      it 'returns full' do
        expect(subject).to eq :full
      end
    end
  end
end
