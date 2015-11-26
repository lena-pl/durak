class Game < ActiveRecord::Base
  belongs_to :trump_card, :class_name => 'Card'
end
