class Game < ActiveRecord::Base
  belongs_to :trump_card, :class_name => 'Card'

  has_many :actions
  has_many :players
end
