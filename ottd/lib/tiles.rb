require_relative 'tile'
require_relative 'sprite'

class Tiles

  def initialize
    # @tile = Tile.new
    @buildings = [
      Sprite.new("building1.png", 1,2),
      Sprite.new("building2.png", 1,2)
    ]
    @road  = Sprite.new("road.png", 1,1)
    @grass = Sprite.new("grass.png", 1,1)

    @grid = []
    10.times do |x|
      10.times do |y|
        add_building(@grass,x,y)
      end
    end

    5.times do |x|
      add_building(@road, x,0)
      add_building(@buildings[0],x, 1)
    end
  end

  def add_building(sprite, x, y)
    @grid[x] ||= []
    @grid[x][y] = Tile.new(sprite, x, y)
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
