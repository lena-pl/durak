class Action < ActiveRecord::Base
  enum kind:[ :draw_new_card, :pick_up_from_table, :attack_with_card, :defend_against_card, :discard ]

  belongs_to :game
  belongs_to :player
  belongs_to :active_card, :class_name => 'Card'
  belongs_to :passive_card, :class_name => 'Card'
end
