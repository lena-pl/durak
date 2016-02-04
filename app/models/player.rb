class Player < ActiveRecord::Base
  belongs_to :game
  has_many :steps, dependent: :destroy

  validates :game, presence: true
end
