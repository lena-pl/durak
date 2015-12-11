require 'rails_helper'

RSpec.describe ApplyDealAction do
  fixtures :cards

  let(:trump_card) { cards(:hearts_7) }
  let(:game) { Game.create!(:trump_card => trump_card) }
  let!(:dealee) { Player.create!(:game => game) }
  let!(:other_player) { Player.create!(:game => game) }
  let(:game_state) { BuildGameState.new(game).call }
  let(:dealee_state) { game_state.player_state_for_player(dealee) }
  let(:other_player_state) { game_state.player_state_for_player(other_player) }

  let(:next_card) { cards(:clubs_11) }
  let(:deal_action) { instance_double(Action) }
  before do
    allow(deal_action).to receive(:card).and_return next_card
    allow(deal_action).to receive(:player).and_return dealee
  end
  subject { ApplyDealAction.new(game_state, deal_action).call }

  describe "#call" do
    context "when the dealee is dealt a card" do
      it "moves the card to their hand" do
        expect(subject.player_state_for_player(dealee).hand).to include next_card
      end
    end

    context "when players have no cards" do
      context "when the dealee is then dealt a non-trump" do
        let(:next_card) { cards(:spades_7) }

        it "makes the first player the new attacker" do
          expect(subject.attacker).to eq game_state.player_states.first.player
        end
      end

      context "when the dealee is then dealt a trump" do
        let(:next_card) { cards(:hearts_9) }

        it "makes the dealee the new attacker" do
          expect(subject.attacker).to eq dealee
        end
      end
    end

    context "when all players have cards" do
      before do
        fill_hand_from_deck(dealee_state, *previously_dealt_dealee)
        fill_hand_from_deck(other_player_state, *previously_dealt_other_player)
      end

      context "when no players have any trumps" do
        let(:previously_dealt_dealee) do
          [cards(:spades_10),
           cards(:clubs_11)]
        end
        let(:previously_dealt_other_player) do
          [cards(:spades_7),
           cards(:clubs_8)]
        end

        context "when the dealee is then dealt a non-trump" do
          let(:next_card) { cards(:diamonds_7) }

          it "makes the first player the new attacker" do
            expect(subject.attacker).to eq game_state.player_states.first.player
          end
        end

        context "when the dealee is then dealt a trump" do
          let(:next_card) { cards(:hearts_11) }

          it "makes them the new attacker" do
            expect(subject.attacker).to eq dealee
          end
        end
      end

      context "when only the other player has a trump" do
        let(:previously_dealt_dealee) do
          [cards(:spades_10),
           cards(:clubs_11)]
        end
        let(:previously_dealt_other_player) do
          [cards(:spades_7),
           cards(:clubs_8),
           cards(:hearts_12)]
        end

        context "when the dealee is then dealt a non-trump" do
          let(:next_card) { cards(:diamonds_7) }

          it "leaves the other player as the attacker" do
            expect(subject.attacker).to eq other_player
          end
        end

        context "when the dealee is dealt a lower trump than the other player" do
          let(:next_card) { cards(:hearts_11) }

          it "makes the dealee the new attacker" do
            expect(subject.attacker).to eq dealee
          end
        end

        context "when the dealee is dealt a higher trump than the other player" do
          let(:next_card) { cards(:hearts_13) }

          it "leaves the other player as the attacker" do
            expect(subject.attacker).to eq other_player
          end
        end
      end

      context "when both players have trumps" do
        context "when the dealee has the lowest trump" do
          let(:previously_dealt_dealee) do
            [cards(:spades_10),
             cards(:hearts_7),
             cards(:hearts_13)]
          end
          let(:previously_dealt_other_player) do
            [cards(:spades_10),
             cards(:hearts_9),
             cards(:hearts_8)]
          end

          context "when the dealee is then dealt a non-trump" do
            let(:next_card) { cards(:diamonds_7) }

            it "leaves the dealee as the attacker" do
              expect(subject.attacker).to eq dealee
            end
          end

          context "when the dealee is then dealt the lowest trump" do
            let(:next_card) { cards(:hearts_6) }

            it "leaves the dealee as the attacker" do
              expect(subject.attacker).to eq dealee
            end
          end

          context "when the dealee is then dealt a higher trump" do
            let(:next_card) { cards(:hearts_14) }

            it "leaves the dealee as the attacker" do
              expect(subject.attacker).to eq dealee
            end
          end
        end

        context "when the other player has the lowest trump" do
          let(:previously_dealt_dealee) do
            [cards(:spades_10),
             cards(:hearts_9),
             cards(:hearts_8)]
          end
          let(:previously_dealt_other_player) do
            [cards(:spades_10),
             cards(:hearts_7),
             cards(:hearts_13)]
          end

          context "when the dealee is then dealt a non-trump" do
            let(:next_card) { cards(:diamonds_7) }

            it "leaves the other_player as the attacker" do
              expect(subject.attacker).to eq other_player
            end
          end

          context "when the dealee is then dealt the lowest trump" do
            let(:next_card) { cards(:hearts_6) }

            it "makes the dealee the new attacker" do
              expect(subject.attacker).to eq dealee
            end
          end

          context "when the dealee is then dealt a higher trump" do
            let(:next_card) { cards(:hearts_14) }

            it "leaves the other_player as the attacker" do
              expect(subject.attacker).to eq other_player
            end
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
