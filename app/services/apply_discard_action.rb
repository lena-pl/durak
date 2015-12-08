class ApplyDiscardAction
  def initialize(game_state, action)
    @game_state = game_state
    @action = action
  end

  def call
    card = @action.active_card

    if !@game_state.table.include?(card)
      raise "Card must be on table to discard"
    end

    @game_state.table.move_to(@game_state.discard_pile, card)

    @game_state.attacker = find_new_attacker

    @game_state
  end

  private

  def find_new_attacker
    if @action.player == @game_state.player(1)
      @game_state.player(2)
    else
      @game_state.player(1)
    end
  end
end
