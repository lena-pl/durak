class Card < ActiveRecord::Base
  enum suit:[ :hearts, :diamonds, :spades, :clubs ]

  validates :suit, :rank, presence: true
  validates :rank, uniqueness: {
    scope: :suit,
    message: "should have only one of each rank per suit",
  }
  validates :rank, numericality: {
    greater_than_or_equal_to: 6,
    less_than_or_equal_to: 14,
  }
end
