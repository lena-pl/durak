class Card < ActiveRecord::Base
  enum suit:[ :hearts, :diamonds, :spades, :clubs ]

  validates :suit, presence: true
  validates :rank, presence: true

  validates :rank, uniqueness: { scope: :suit,
    message: "should only have 14 cards per suit" }

  validates :rank, numericality: { greater_than: 5, less_than: 15 }
end
