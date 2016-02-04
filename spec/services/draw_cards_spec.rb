require 'rails_helper'

describe DrawCards do
  fixtures :cards

  let(:trump_card) { cards(:hearts_7) }
  let(:game) { Game.create!(trump_card: trump_card) }
  let(:game_state) { BuildGameState.new(game).call }

  let!(:attacker) { game.players.create! }
  let(:attacker_state) { game_state.player_state_for_player(attacker) }
  let!(:defender) { game.players.create! }
  let(:defender_state) { game_state.player_state_for_player(defender) }

  subject { DrawCards.new(game_state) }

  describe "#call" do
    before do
      fill_hand_from_deck(attacker_state, *attacker_hand)
      fill_hand_from_deck(defender_state, *defender_hand)
    end

    context "when both players have the standard amount of cards" do
      let(:attacker_hand) do
        [cards(:spades_7),
         cards(:spades_8),
         cards(:spades_9),
         cards(:spades_10),
         cards(:spades_11),
         cards(:spades_12)]
      end

      let(:defender_hand) do
        [cards(:clubs_7),
         cards(:clubs_8),
         cards(:clubs_9),
         cards(:clubs_10),
         cards(:clubs_11),
         cards(:clubs_12)]
      end

      context "when the deck is full" do
        it "does not draw any cards for the attacker" do
          subject.call

          expect(attacker.steps).to be_empty
        end

        it "does not draw any cards for the defender" do
          subject.call

          expect(attacker.steps).to be_empty
        end
      end

      context "when the deck is empty" do
        before do
          game_state.deck.clear
        end

        it "does not draw any cards for the attacker" do
          subject.call

          expect(attacker.steps).to be_empty
        end

        it "does not draw any cards for the defender" do
          subject.call

          expect(defender.steps).to be_empty
        end
      end
    end

    context "when one player has 2 less than the standard amount of cards" do
      let(:attacker_hand) do
        [cards(:spades_7),
         cards(:spades_8),
         cards(:spades_9),
         cards(:spades_12)]
      end

      let(:defender_hand) do
        [cards(:clubs_7),
         cards(:clubs_8),
         cards(:clubs_9),
         cards(:clubs_10),
         cards(:clubs_11),
         cards(:clubs_12)]
      end

      context "when the deck is full" do
        it "draws 2 cards to the player" do
          subject.call

          expect(attacker).to have_exactly(2).steps
          expect(attacker.steps.all?(&:draw_from_deck?)).to be true
        end

        it "does not draw cards for the other player" do
          subject.call

          expect(defender.steps).to be_empty
        end
      end

      context "when the deck is empty" do
        before do
          game_state.deck.clear
        end

        it "does not draw any cards for the attacker" do
          subject.call

          expect(attacker.steps).to be_empty
        end

        it "does not draw any cards for the defender" do
          subject.call

          expect(defender.steps).to be_empty
        end
      end

      context "when the deck does not have enough cards (i.e 1 card left)" do
        before do
          game_state.deck.clear
          game_state.deck.push(trump_card)
        end

        it "draws the 1 remaining card to the player" do
          subject.call

          expect(attacker).to have_exactly(1).steps
        end
      end
    end

    context "when both players have 4 less than the standard amount of cards" do
      let(:attacker_hand) do
        [cards(:spades_7),
         cards(:spades_12)]
      end

      let(:defender_hand) do
        [cards(:clubs_7),
         cards(:clubs_12)]
      end

      context "when the deck is full" do
        it "draws 4 cards to the first player" do
          subject.call

          expect(attacker).to have_exactly(4).steps
          expect(attacker.steps.all?(&:draw_from_deck?)).to be true
        end

        it "draws 4 cards to the second player" do
          subject.call

          expect(defender).to have_exactly(4).steps
          expect(defender.steps.all?(&:draw_from_deck?)).to be true
        end
      end

      context "when the deck is empty" do
        before do
          game_state.deck.clear
        end

        it "does not draw any cards for the attacker" do
          subject.call

          expect(attacker.steps).to be_empty
        end

        it "does not draw any cards for the defender" do
          subject.call

          expect(defender.steps).to be_empty
        end
      end

      context "when the deck has an even amount of cards left" do
        context "when the deck has 2 cards left" do
          before do
            game_state.deck.clear
            game_state.deck.push(trump_card)
            game_state.deck.push(cards(:diamonds_12))
          end

          it "draws 1 card to each player" do
            subject.call

            expect(attacker).to have_exactly(1).steps
            expect(attacker.steps.all?(&:draw_from_deck?)).to be true

            expect(defender).to have_exactly(1).steps
            expect(defender.steps.all?(&:draw_from_deck?)).to be true
          end
        end

        context "when the deck has 4 cards left" do
          before do
            game_state.deck.clear
            game_state.deck.push(trump_card)
            game_state.deck.push(cards(:diamonds_12))
            game_state.deck.push(cards(:diamonds_11))
            game_state.deck.push(cards(:diamonds_10))
          end

          it "draws 2 cards to each player" do
            subject.call

            expect(attacker).to have_exactly(2).steps
            expect(attacker.steps.all?(&:draw_from_deck?)).to be true

            expect(defender).to have_exactly(2).steps
            expect(defender.steps.all?(&:draw_from_deck?)).to be true
          end
        end
      end

      context "when the deck has an odd amount of cards left" do
        context "when the deck has 3 cards left" do
          before do
            game_state.deck.clear
            game_state.deck.push(trump_card)
            game_state.deck.push(cards(:diamonds_12))
            game_state.deck.push(cards(:diamonds_11))
          end

          it "draws 2 cards to the attacker" do
            subject.call

            expect(attacker).to have_exactly(2).steps
            expect(attacker.steps.all?(&:draw_from_deck?)).to be true
          end

          it "draws 1 card to the defender" do
            subject.call

            expect(defender).to have_exactly(1).steps
            expect(defender.steps.all?(&:draw_from_deck?)).to be true
          end
        end
      end
    end
  end

  def fill_hand_from_deck(player_state, *cards)
    cards.each { |card| move_from_deck_to(player_state, card) }
  end

  def move_from_deck_to(player_state, card)
    game_state.deck.delete(card)
    player_state.hand.push(card)
  end
end
