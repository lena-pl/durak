require 'rails_helper'

RSpec.describe GamesController, type: :controller do
  fixtures :cards

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
      it 'redirects to show page' do
        post :create
        expect(response).to redirect_to(Game.last)
      end
    end
  end

  describe "GET #show" do
    let(:game) { Game.create!(trump_card: cards(:hearts_6)) }
    subject { get :show, :id => game }

    it "renders the show template" do
      expect(subject).to render_template(:show)
    end

    it "assigns @game" do
      subject
      expect(assigns(:game)).to be_a Game
    end

    it "builds a new game state" do
      expect_any_instance_of(BuildGameState).to receive(:call)
      
      subject
    end
  end
end
