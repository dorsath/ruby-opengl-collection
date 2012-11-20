class Population
  attr_reader :citizens

  def initialize(options)
    @grid    = options[:grid]
    @citizens = options[:citizens] || []

  end

  def new_citizen(options)
    options[:grid] = @grid
    citizen = Citizen.new(options)
    @citizens << citizen

    citizen
  end

  def draw
    @citizens.each(&:draw)
  end

  def mouse_handler(*args)
    if @grid.active_tool == :move
      position = @grid.grid_position_from_coordinates(*args[2..3])
      p "moving towards: #{position}"
      citizens.each do |citizen|
        citizen.move_towards(position)
      end
    end

    false
  end

end
