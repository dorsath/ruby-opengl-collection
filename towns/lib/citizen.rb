class Citizen
  attr_reader :position, :destination

  def initialize(options)
    @position = options[:position]
    @grid = options[:grid]

    @sprites = (0..4).map do |i|
      (0..5).map do |d|
        Sprite.find("citizenmale.png", (d * 64), (i * 65), 60, 65)
      end
    end
  end

  def move_towards(destination)
    @destination = destination

    @next_step = find_next_step
    @start_time = time
    @offset = [0, 0]
    @current_sprite_direction = sprite_for_current_direction
  end

  def find_next_step
    [destination, position].transpose.map do |x| 
      difference = x.reduce(:-)
      difference == 0 ? 0 : (difference / (difference.abs))
    end
  end

  def move
    movement_speed = 0.5
    current_moment = (movement_speed.to_f / (time - @start_time))

    @offset = distance_to_cover.map do |axis|
      axis.to_f / current_moment
    end

    if current_moment < 1
      @offset = [0, 0]
      @position = [position[0] + @next_step[0], position[1] + @next_step[1]]
      @next_step = find_next_step
      @current_sprite_direction = sprite_for_current_direction
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
      texture: current_sprite,
      position: absolute_position
    }
  end

  def current_sprite
    @current_step ||= 0
    @step_time ||= time

    if time - @step_time > 0.1
      @current_step += 1
      @step_time = time
      @current_step = 0 if @current_step > 5 || @next_step == [0, 0]
    end

    sprite = @sprites[@current_sprite_direction][@current_step].texture_id

    {texture_id: sprite, flipped: @flipped}
  end

  def sprite_for_current_direction
    return @current_sprite_direction if @next_step == [0, 0]

    flipped?

    case(@next_step) 
    when [1, 1]
      1
    when [-1, -1]
      0
    when [1, 0], [0, 1]
      2
    when [1, -1], [-1, 1]
      3
    when [0, -1], [-1, 0]
      4
    else
      @current_sprite_direction
    end
  end

  def flipped?
    @flipped = [[0, 1], [-1, 1], [-1, 0]].include?(@next_step)
  end

  def absolute_position
    [@grid.screen_coordinate_from_position(*position), @offset].transpose.map { |x| x.reduce(:+) }
  end
end
