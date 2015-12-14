class TestGame
  attr_reader :game_model
  delegate :trump_card, :players, to: :game_model

  def initialize(trump_card)
    @game_model = CreateGame.new(trump_card).call
  end

  def apply_actions(&block)
    block.call(self)
  end

  def attack(player, card)
    create_action(:attack, player, card)
  end

  def defend(player, card, in_response_to_action)
    create_action(:defend, player, card, in_response_to_action)
  end

  def discard(player, card)
    create_action(:discard, player, card)
  end

  def draw_from_deck(player, card)
    create_action(:draw_from_deck, player, card)
  end

  def pick_up_from_table(player, card)
    create_action(:pick_up_from_table, player, card)
  end

  def deal_card(player, card)
    create_action(:deal, player, card)
  end

  private

  def create_action(kind, player, card, in_response_to_action = nil)
    player.actions.create!(kind: kind, card: card, in_response_to_action: in_response_to_action)
  end
end
