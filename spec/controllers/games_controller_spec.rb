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
      player_one.update_attributes(token: SecureRandom.hex)
      request.session["player_token"] = player_one.token
    end

    it "assigns the current player" do
      subject

      expect(:current_player).to_not be_nil
    end

    context "the second player is not connected" do
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
        player_one.update_attributes(token: SecureRandom.hex)
        player_two.update_attributes(token: SecureRandom.hex)

        session["player_token"] = player_one.token
      end

      it "renders the show template" do
        expect(subject).to render_template(:show)
      end

      it "builds a new game state" do
        expect_any_instance_of(BuildGameState).to receive(:call)

        subject
      end

      context "the request is xhr and step id is a param" do
        before do
          player_one.steps.create!(kind: :deal, card: cards(:hearts_7))
        end

        it "renders show when step ids match but the submitted param is set to true" do
          expect(subject).to render_template(:show)

          xhr :get, :show, id: game.id, last_id: game.steps.last.id.to_i, submitted: "true"
        end

        it "returns head not modified when step ids match and the submitted param is set to false" do
          xhr :get, :show, id: game.id, last_id: game.steps.last.id.to_i, submitted: "false"

          expect(response).to have_http_status(:not_modified)
        end

        it "renders show when step ids don't match" do
          expect(subject).to render_template(:show)

          xhr :get, :show, id: game.id, last_id: game.steps.last.id.to_i + 1
        end
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

    context "when the current player is the game owner" do
      it 'redirects to invite friend page with a notice' do
        allow_any_instance_of(ConnectPlayer).to receive(:call).and_return :game_owner

        get :join, id: game.id

        expect(flash.notice).to eq "You can't join your own game!"
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
