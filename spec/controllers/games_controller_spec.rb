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

        expect(response).to redirect_to(controller: 'games', action: 'show', id: Game.last.id)
      end
    end
  end

  describe "GET #show" do
    subject { get :show, id: game.id }

    before do
      session["game_#{game.id}_token".to_sym] = player_one.token
    end

    it "assigns the current player" do
      subject

      expect(:current_player).to_not be_nil
    end

    context "the second player is not connected" do
      before do
        game.players.first.update_attributes(connected: true)
      end

      it "renders the invite_friend template" do
        expect(subject).to render_template(:invite_friend)
      end

      it "builds a new game state" do
        expect_any_instance_of(BuildGameState).to receive(:call)

        subject
      end
    end

    context "the second player is connected" do
      before do
        game.players.first.update_attributes(connected: true)
        game.players.second.update_attributes(connected: true)
      end

      it "renders the show template" do
        expect(subject).to render_template(:show)
      end

      it "builds a new game state" do
        expect_any_instance_of(BuildGameState).to receive(:call)

        subject
      end
    end
  end

  describe "GET #join" do
    context "when the game is not full" do
      it 'redirects to show page' do
        allow_any_instance_of(ConnectPlayer).to receive(:call).and_return :ok

        get :join, id: game.id

        expect(response).to redirect_to(controller: 'games', action: 'show', id: game.id)
      end
    end

    context "when the game is full" do
      it 'redirects to game full page' do
        allow_any_instance_of(ConnectPlayer).to receive(:call).and_return :full

        get :join, id: game.id

        expect(response).to render_template(:game_full)
      end
    end
  end
end
