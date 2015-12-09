class Game < ActiveRecord::Base
  belongs_to :trump_card, :class_name => 'Card'

  has_many :actions, through: :players, dependent: :destroy
  has_many :players, dependent: :destroy

  validates :trump_card, presence: true
end
