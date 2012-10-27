require_relative 'tile'
require_relative 'sprite'

Dir[File.dirname(__FILE__) + '/tiles/*.rb'].each {|file| require file }


class Tiles

  def initialize(width, height)
    @width, @height = width, height
    @camera = [0,50]
    @zoom = 1
    # @tile = Tile.new
    # @buildings = [
    #   Sprite.new("building1.png", 1,2),
    #   Sprite.new("building2.png", 1,2)
    # ]
    
    @grass = Grass
    @road  = Road
    @building = Building

    @grid = []
    width.times do |x|
      height.times do |y|
        set_tile(@grass,x,y)
      end
    end

    5.times do |x|
      set_tile(@road, x,0)
      set_tile(@building, x, 1)
    end
  end

  def handle_keys(active_keys, dt)
    camera_speed = 500
    if active_keys[100]
      @camera[0] += camera_speed * dt
    end
    if active_keys[101]
      @camera[1] += camera_speed * dt
    end
    if active_keys[102]
      @camera[0] -= camera_speed * dt
    end
    if active_keys[103]
      @camera[1] -= camera_speed * dt
    end
  end

  def handle_single_keys(key)
    zoom_stages = [0.25,0.5,1,2]
    case key
    when 45
      @zoom = zoom_stages[zoom_stages.index(@zoom) - 1]
    when 61
      @zoom = zoom_stages[zoom_stages.index(@zoom) + 1] if zoom_stages.index(@zoom) + 1 < zoom_stages.length
    end
  end

  def handle(button, x, y, tool)
    if tool
      x, y = get_tile_coordinates_of_position(x,y)
      set_tile(tool, x,y)
    end
  end

  def placeable
    [@road, @grass, @building]
  end

  def set_tile(tile, x, y)
    if (0..@width).include?(x) && (0..@height).include?(y)
      @grid[x] ||= []
      @grid[x][y] = tile.new(x, y, self)
    end
  end

  def draw
    glTranslate(*@camera, 0)
    glScale(@zoom, @zoom, @zoom)
    @grid.reverse.each_with_index do |row, x|
      row.reverse.each_with_index do |tile, y|
        tile.draw
      end
    end
  end

  def highlight_tile(tile)
    if tile != @last_highlight
      tile.highlight = true if tile
      @last_highlight.highlight = false if @last_highlight

      @last_highlight = tile
    end
  end

  def get_tile(x,y)
    if @grid[x].is_a?(Array)
      @grid[x][y]
    end
  end

  def get_tile_from_absolute(x,y)
    x, y = get_tile_coordinates_of_position(x,y)
    if @grid[x].is_a?(Array) && !@grid[x][y].nil?
      @grid[x][y]
    else
      false
    end
  end

  def get_tile_coordinates_of_position(x,y)
    x = 320 - x + @camera[0]
    y = 480 - y + @camera[1]

    _x = (y/32.0 + x/64.0).floor
    _y = (-x/64.0 + y/32.0).floor

    [_x,_y]
  end
end
