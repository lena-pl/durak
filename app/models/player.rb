class Player < ActiveRecord::Base
  belongs_to :game

  has_many :actions

  validates :game, presence: true
end
