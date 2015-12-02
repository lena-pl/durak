require 'rails_helper'

RSpec.describe ApplyChooseTrumpAction do
  
  let(:base_game_state) { GameState.base_state }
  
  describe "#call" do
    let(:trump_card) { Card.new(:rank => 7, :suit => :hearts) }
    let(:choose_trump_action) { Action.new(:kind => :choose_trump, :active_card => trump_card) }

    it "changes the trump card to the trump card given by the action" do
      game_state = ApplyChooseTrumpAction.new(base_game_state, choose_trump_action).call
      expect(game_state.trump_card).to eq trump_card 
    end
  end

end
