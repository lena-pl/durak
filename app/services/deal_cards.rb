class DealCards
  def initialize(game_state)
    @game_state = game_state
  end

  def call
    @game_state.player_states.each do |player_state|
      GameState::STANDARD_HAND_SIZE.times do
        PickUpFromDeck.new(@game_state, player_state, :deal).call
      end
    end
  end
end
