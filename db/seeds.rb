# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

def seed_initial_cards
  Card.suits.each do |suit, enumeration|
    6.upto(14) do |rank|
      Card.create!(rank: rank, suit: suit)
    end
  end
end

seed_initial_cards

