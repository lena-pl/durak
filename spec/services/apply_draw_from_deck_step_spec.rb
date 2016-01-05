require 'rails_helper'

RSpec.describe ApplyDrawFromDeckStep do
  fixtures :cards

  let(:game) { Game.new(trump_card: cards(:hearts_7)) }
  let!(:drawer) { game.players.new }
  let(:game_state) { BuildGameState.new(game).call }

  let(:card_to_draw) { cards(:clubs_10) }

  let(:draw_from_deck_step) { instance_double(Step) }
  before do
    allow(draw_from_deck_step).to receive(:card).and_return(card_to_draw)
    allow(draw_from_deck_step).to receive(:player).and_return(drawer)
  end
  subject { ApplyDrawFromDeckStep.new(game_state, draw_from_deck_step).call }

  describe "#call" do
    context "drawer draws a card from the deck" do
      it "moves that card to their hand" do
        drawer_state = subject.player_state_for_player(drawer)
        expect(drawer_state.hand).to include card_to_draw
      end

      it "takes that card out of deck" do
        expect(subject.deck).to_not include card_to_draw
      end

      it "leaves other cards in deck" do
        expect(subject.deck).to include(*(Card.all - [card_to_draw]))
      end

      it "does not move other cards to their hand" do
        player_state = subject.player_state_for_player(drawer)
        expect(player_state.hand.count).to eq 1
      end
    end

    context "when the card being picked up isn't in the deck" do
      before do
        game_state.deck.delete(card_to_draw)
      end

      it "raises error" do
        expect{ subject }.to raise_error("Card must be in deck to be drawn")
      end
    end
  end
end
