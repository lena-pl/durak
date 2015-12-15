class Step < ActiveRecord::Base
  belongs_to :player
  belongs_to :card
  belongs_to :in_response_to_step, :class_name => 'Step'

  enum kind: [:deal, :draw_from_deck, :pick_up_from_table, :attack, :defend, :discard]

  validates :kind, :player, :card, presence: true
  validates :in_response_to_step, uniqueness: true, allow_nil: true
  validates :in_response_to_step, presence: true, if: :defend?
end
