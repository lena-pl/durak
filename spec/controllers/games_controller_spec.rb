require 'rails_helper'

RSpec.describe GamesController, type: :controller do
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
end
