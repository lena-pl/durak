class Card < ActiveRecord::Base
  enum suit:[ :hearts, :diamonds, :spades, :clubs ]
end
