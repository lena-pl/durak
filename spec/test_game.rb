class TestGame
  attr_reader :game_model
  delegate :trump_card, :players, to: :game_model

  def initialize(trump_card)
    @game_model = Game.create!(trump_card: trump_card)
    2.times { @game_model.players.create! }
  end
  
  def attack(player, card)
    create_step(:attack, player, card)
  end

  def defend(player, card, in_response_to_step)
    create_step(:defend, player, card, in_response_to_step)
  end

  def discard(player)
    create_step(:discard, player)
  end

  def draw_from_deck(player, card)
    create_step(:draw_from_deck, player, card)
  end

  def pick_up_from_table(player)
    create_step(:pick_up_from_table, player)
  end

  def deal_card(player, card)
    create_step(:deal, player, card)
  end

  private

  def create_step(kind, player, card = nil, in_response_to_step = nil)
    player.steps.create!(kind: kind, card: card, in_response_to_step: in_response_to_step)
  end
end
