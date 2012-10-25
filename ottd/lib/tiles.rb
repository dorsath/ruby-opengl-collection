require_relative 'tile'
require_relative 'sprite'

class Tiles

  def initialize
    # @tile = Tile.new
    @buildings = [
      Sprite.new("building1.png", 1,2),
      Sprite.new("building2.png", 1,2)
    ]
    @road = Sprite.new("road.png", 1,1)

    @grid = []

    add_building(@road, 0,0)
    add_building(@road, 1,0)
    add_building(@road, 2,0)
    add_building(@road, 3,0)
  end

  def add_building(sprite, x, y)
    @grid[x] ||= []
    @grid[x][y] = Tile.new(sprite, x, y)
  end

  def draw
    @grid.each_with_index do |row, x|
      row.each_with_index do |tile, y|
        tile.draw
      end
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
