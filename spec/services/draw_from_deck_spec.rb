require 'rails_helper'

describe DrawFromDeck do
  fixtures :cards

  let(:trump_card) { cards(:hearts_7) }
  let(:game) { CreateGame.new(trump_card, session: { "player_token" => SecureRandom.hex }).call }
  let(:game_state) { BuildGameState.new(game).call }

  let(:player) { game.players.first }
  let(:player_state) { game_state.player_state_for_player(player) }

  subject { DrawFromDeck.new(game_state, player_state, :draw_from_deck) }

  describe "#call" do
    context "when the deck is empty" do
      before do
        game_state.deck.clear
      end

      it "raises correct error" do
        expect { subject.call }.to raise_error("Cannot draw from empty deck")
      end
    end

    context "when only the trump card is left" do
      before do
        game_state.deck.clear
        game_state.deck.push(trump_card)
      end

      it "picks up the trump card" do
          subject.call

          expect(player.steps.last.card).to eq trump_card
      end

      it "makes the deck empty" do
        subject.call

        expect(game_state.deck).to be_empty
      end

      context "when there is also one other card" do
        let(:one_other_card) { cards(:hearts_13) }

        before do
          game_state.deck.clear
          game_state.deck.push(trump_card)
          game_state.deck.push(one_other_card)
        end

        it "picks up the other card" do
          subject.call

          expect(player.steps.last.card).to eq one_other_card
        end

        it "leaves the trump card in the deck" do
          subject.call

          expect(game_state.deck).to include(trump_card)
        end
      end
    end
  end
end
