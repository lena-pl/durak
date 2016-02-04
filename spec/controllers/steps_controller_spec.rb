require 'rails_helper'

RSpec.describe StepsController, type: :controller do
  fixtures :cards

  let(:game) { Game.create!(trump_card: cards(:hearts_6)) }
  let!(:player_one) { game.players.create! }
  let!(:player_two) { game.players.create! }

  describe "POST create" do
    context "player one is the attacker" do
      before do
        player_one.update_attributes(token: SecureRandom.hex)
        player_two.update_attributes(token: SecureRandom.hex)

        player_one.steps.create!(kind: :deal, card: cards(:hearts_10))
        player_one.steps.create!(kind: :deal, card: cards(:spades_7))

        player_two.steps.create!(kind: :deal, card: cards(:spades_8))
        player_two.steps.create!(kind: :deal, card: cards(:spades_9))
      end

      context "there are no step params" do
        context "there are cards on the table" do
          before do
            attacking_step = player_one.steps.create!(kind: :attack, card: cards(:spades_7))
            player_two.steps.create!(kind: :defend, card: cards(:spades_8), in_response_to_step: attacking_step)

            session["player_token"] = player_one.token
          end

          it "calls end turn" do
            expect_any_instance_of(EndTurn).to receive(:call)

            post :create, game_id: game, player_id: player_one
          end

          it "renders nothing" do
            post :create, game_id: game, player_id: player_one

            expect(response.body).to be_blank
          end
        end
      end

      context "there is a step param for card_id" do
        before do
          session["player_token"] = player_one.token
        end

        it "calls play card" do
          expect_any_instance_of(PlayCard).to receive(:call)

          post :create, game_id: game, player_id: player_one, step: {card_id: cards(:spades_7)}
        end

        it "renders nothing" do
          post :create, game_id: game, player_id: player_one, step: {card_id: cards(:spades_7)}

          expect(response.body).to be_blank
        end
      end

      context "attacker plays a trump and defender tries to defend with a non-trump" do
        before do
          player_one.steps.create!(kind: :attack, card: cards(:hearts_10))

          session["player_token"] = player_two.token
        end

        it "returns errors" do
          post :create, game_id: game, player_id: player_two, step: {card_id: cards(:spades_8)}

          expect(flash.alert).to eq ["You must defend with a card of higher rank or a trump!", "You must defend with a card of the same suit or a trump!"]
        end
      end
    end
  end
end
