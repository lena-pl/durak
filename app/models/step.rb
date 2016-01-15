class Step < ActiveRecord::Base
  belongs_to :player
  belongs_to :card
  belongs_to :in_response_to_step, :class_name => 'Step'

  enum kind: [:deal, :draw_from_deck, :pick_up_from_table, :attack, :defend, :discard]
  ATTACK = "attack"
  DRAW_FROM_DECK = "draw_from_deck"

  validates :kind, :player, presence: true
  validates :card, presence: true, unless: :card_not_needed?
  validates :in_response_to_step, uniqueness: true, allow_nil: true
  validates :in_response_to_step, presence: true, if: :defend?

  private

  def card_not_needed?
    pick_up_from_table? || discard?
  end
end
