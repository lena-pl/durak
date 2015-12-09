class Action < ActiveRecord::Base
  belongs_to :game
  belongs_to :player
  belongs_to :card
  belongs_to :in_response_to_action, :class_name => 'Action'

  enum kind: [:deal, :draw_from_deck, :pick_up_from_table, :attack, :defend, :discard]

  validates :game, :player, :card, presence: true
  validates :in_response_to_action, uniqueness: true
end
