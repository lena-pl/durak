class Game < ActiveRecord::Base
  belongs_to :trump_card, :class_name => 'Card'

  has_many :actions, through: :players
  has_many :players

  validates :trump_card, presence: true
end
