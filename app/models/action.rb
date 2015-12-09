class Action < ActiveRecord::Base
  enum kind:[:deal, :draw_from_deck, :pick_up_from_table, :attack, :defend, :discard]

  belongs_to :game
  belongs_to :player
  belongs_to :card
  belongs_to :in_response_to_action, :class_name => 'Action'

  validates :game, presence: true
  validates :player, presence: true
  validates :card, presence: true
end
