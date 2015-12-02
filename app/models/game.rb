class Game < ActiveRecord::Base
  has_many :actions
  has_many :players
end
