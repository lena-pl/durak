class TestGame
  attr_reader :game_model

  def initialize(trump_card)
    @game_model = CreateGame.new(trump_card).call
  end

  def apply_actions(&block)
    block.call(self)
  end

  def deal_card(player, card)
    create_action(:deal, player, card)
  end

  private

  def create_action(kind, player, active_card, passive_card = nil)
    @game_model.actions.create!(kind: kind, player: player, active_card: active_card, passive_card: passive_card)
  end

end
