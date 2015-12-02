class Action < ActiveRecord::Base
  enum kind:[:choose_trump, :deal, :draw_from_deck, :pick_up_from_table, :attack, :defend, :discard]

  belongs_to :game
  belongs_to :initiating_player, :class_name => 'Player'
  belongs_to :affected_player, :class_name => 'Player'
  belongs_to :active_card, :class_name => 'Card'
  belongs_to :passive_card, :class_name => 'Card'
end
