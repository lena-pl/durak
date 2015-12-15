class TestGame
  attr_reader :game_model
  delegate :trump_card, :players, to: :game_model

  def initialize(trump_card)
    @game_model = CreateGame.new(trump_card).call
  end

  def apply_steps(&block)
    block.call(self)
  end

  def attack(player, card)
    create_step(:attack, player, card)
  end

  def defend(player, card, in_response_to_step)
    create_step(:defend, player, card, in_response_to_step)
  end

  def discard(player, card)
    create_step(:discard, player, card)
  end

  def draw_from_deck(player, card)
    create_step(:draw_from_deck, player, card)
  end

  def pick_up_from_table(player, card)
    create_step(:pick_up_from_table, player, card)
  end

  def deal_card(player, card)
    create_step(:deal, player, card)
  end

  private

  def create_step(kind, player, card, in_response_to_step = nil)
    player.steps.create!(kind: kind, card: card, in_response_to_step: in_response_to_step)
  end
end
