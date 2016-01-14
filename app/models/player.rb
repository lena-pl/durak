class Player < ActiveRecord::Base
  belongs_to :game
  has_many :steps, dependent: :destroy

  before_create :generate_token

  validates :game, presence: true

  private

  def generate_token
    begin
      self.token = SecureRandom.hex
    end while self.class.exists?(token: token)
  end
end
