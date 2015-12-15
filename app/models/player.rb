class Player < ActiveRecord::Base
  belongs_to :game

  has_many :steps

  validates :game, presence: true
end
