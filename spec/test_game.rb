class TestGame
  attr_reader :game_model

  def initialize(trump_card)
    @game_model = CreateGame.new(trump_card).call
  end

  def apply_actions(&block)
    block.call(self)
  end

  def deal_card(player, card, in_response_to_action = nil)
    create_action(:deal, player, card, in_response_to_action)
  end

  private

  def create_action(kind, player, card, in_response_to_action)
    player.actions.create!(kind: kind, card: card, in_response_to_action: in_response_to_action)
  end
end
