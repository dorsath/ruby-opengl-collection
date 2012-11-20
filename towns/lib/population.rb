class Population
  attr_reader :citizen

  def initialize(options)
    @grid    = options[:grid]
    @citizen = options[:citizen] || []

  end

  def new_citizen(options)
    options[:grid] = @grid
    citizen = Citizen.new(options)
    @citizen << citizen

    citizen
  end

  def draw
    @citizen.each(&:draw)
  end

end
