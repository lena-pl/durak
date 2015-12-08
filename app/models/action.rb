class Action < ActiveRecord::Base
  enum kind:[:deal, :draw_from_deck, :pick_up_from_table, :attack, :defend, :discard]

  belongs_to :game
  belongs_to :player
  belongs_to :active_card, :class_name => 'Card'
  belongs_to :passive_card, :class_name => 'Card'
end
