class Population
  attr_reader :citizen

  def initialize(options)
    @grid    = options[:grid]
    @citizen = options[:citizen] || []
  end

  def add_citizen(citizen)
    @citizen << citizen
  end

  def draw
    @citizen.each do |citizen|
    end
  end

end
