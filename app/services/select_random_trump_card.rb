class SelectRandomTrumpCard
  def call
    Card.order("RANDOM()").first
  end
end
