require_relative 'tile'

class Tiles

  def initialize
    # @tile = Tile.new
    @buildings = [
      Tile.new("building1.png", 1,2),
      Tile.new("building2.png", 1,2)
    ]
    @road = Tile.new("road.png", 1,1)
  end


  def draw
    # @buildings[0].draw(2,1)
    # @buildings[1].draw(1,1)
    10.times do |x|
      10.times do |y|
        @road.draw(x,y)
      end
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
