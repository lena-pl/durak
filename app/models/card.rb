class Card < ActiveRecord::Base
  RANK_RANGE = 6..14

  enum suit: [ :hearts, :diamonds, :spades, :clubs ]

  validates :suit, :rank, presence: true
  validates :rank, uniqueness: {
    scope: :suit,
    message: "should have only one of each rank per suit",
  }
  validates :rank, inclusion: {in: RANK_RANGE}
end
