class Action < ActiveRecord::Base
  enum kind:[ :pick_up_from_deck, :pick_up_from_table, :put_down_on_table, :discard ]

  belongs_to :game
  belongs_to :player
  belongs_to :card
end
