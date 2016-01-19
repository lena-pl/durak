class Player < ActiveRecord::Base
  belongs_to :game
  has_many :steps, dependent: :destroy

  before_create :generate_token

  validates :game, presence: true

  private

  def generate_token
    self.token = SecureRandom.hex
  end
end
