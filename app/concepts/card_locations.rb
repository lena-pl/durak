class CardLocations
  def initialize(**locations)
    locations.each do |location, cards|
      locations[location] = cards.clone.to_a
    end

    @locations = locations
  end

  def move(from, to, card)
    @locations[from].delete(card)

    if !@locations[to] 
      @locations[to] = []
    end

    @locations[to].push(card)
  end

  def at(location)
    location = @locations[location]

    if !location
      []
    else
      location
    end
  end
end
