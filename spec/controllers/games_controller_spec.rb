require 'rails_helper'

RSpec.describe GamesController, type: :controller do
  fixtures :cards

  let(:game) { Game.create!(trump_card: cards(:hearts_6)) }
  let!(:player_one) { game.players.create! }
  let!(:player_two) { game.players.create! }

  describe "GET new" do
    it "has a 200 status code" do
      get :new

      expect(response.status).to eq 200
    end

    it "assigns @game" do
      get :new

      expect(assigns(:game)).to be_a_new Game
    end

    it "renders the new game template" do
      get :new

      expect(response).to render_template :new
    end
  end

  describe "POST create" do
    context 'after creation' do
      it 'redirects to show' do
        post :create

        expect(response).to redirect_to(controller: 'games', action: 'show', id: Game.last.id, player_id: Game.last.players.first.id)
      end
    end
  end

  describe "GET #show" do
    subject { get :show, :id => game }

    it "renders the show template" do
      expect(subject).to render_template(:invite_friend)
    end

    it "builds a new game state" do
      expect_any_instance_of(BuildGameState).to receive(:call)

      subject
    end
  end

  describe "GET #join" do

    it "connects the second player" do
      get :join, id: game.id

      expect(game.players.second.connected).to eq true
    end

    it 'redirects to show page' do
      get :join, id: game.id

      expect(response).to redirect_to(redirect_to controller: 'games', action: 'show', id: game.id, player_id: player_two.id)
    end
  end
end
