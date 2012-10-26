require_relative 'tile'
require_relative 'sprite'

Dir[File.dirname(__FILE__) + '/tiles/*.rb'].each {|file| require file }


class Tiles

  def initialize(width, height)
    @width, @height = width, height
    # @tile = Tile.new
    # @buildings = [
    #   Sprite.new("building1.png", 1,2),
    #   Sprite.new("building2.png", 1,2)
    # ]
    
    @grass = Grass
    @road  = Road
    @building = Building

    @grid = []
    10.times do |x|
      10.times do |y|
        set_tile(@grass,x,y)
      end
    end

    5.times do |x|
      set_tile(@road, x,0)
      set_tile(@building, x, 1)
    end
  end

  def handle(button, x, y, tool)
    if tool
      x, y = get_tile_coordinates_of_position(x,y)
      set_tile(tool, x,y)
    end
  end

  def placeable
    [@road, @grass]
  end

  def set_tile(tile, x, y)
    if (0..@width).include?(x) && (0..@height).include?(y)
      @grid[x] ||= []
      @grid[x][y] = tile.new(x, y, self)
    end
  end

  def draw
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
    x = 320 - x
    y = 480 - y

    _x = (y/32.0 + x/64.0).floor
    _y = (-x/64.0 + y/32.0).floor

    [_x,_y]
  end
end
