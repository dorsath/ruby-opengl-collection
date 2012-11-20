class Citizen
  attr_reader :position, :sprite

  def initialize(options)
    @position = options[:position]
    @grid = options[:grid]

    @sprite = Sprite.find("citizenmale.png", 0, 0, 60, 60)

  end

  def move_towards(destination)
    @destination = destination

    @next_step = find_next_step(destination)
    @start_time = time
    @offset = [0, 0]
  end

  def find_next_step(destination)
    [@destination, position].transpose.map { |x| x.reduce(:-) == 0 ? 0 : 1 }
  end

  def move
    moments_per_tile_change = 1
    current_moment = (moments_per_tile_change.to_f / (time - @start_time))

    @offset = distance_to_cover.map do |axis|
      axis.to_f / current_moment
    end

    if current_moment < moments_per_tile_change
      @offset = [0, 0]
      @position = [position[0] + @next_step[0], position[1] + @next_step[1]]
      @next_step = find_next_step(@destination)
      @start_time = time
    end
  end

  def distance_to_cover
    point_1 = @grid.screen_coordinate_from_position(*position)
    point_2 = @grid.screen_coordinate_from_position(position[0] + @next_step[0], position[1] + @next_step[1])

    [point_2[0] - point_1[0], point_2[1] - point_1[1]]
  end

  def time
    Time.now.to_f
  end

  def draw
    move unless @destination.nil? or @destination == position

    Walker::Base.driver.draw.citizen(options)
  end

  def options
    {
      texture: sprite,
      position: absolute_position
    }
  end

  def absolute_position
    [@grid.screen_coordinate_from_position(*position), @offset].transpose.map { |x| x.reduce(:+) }
  end
end
