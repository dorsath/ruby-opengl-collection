require_relative 'base'
require_relative 'tiles'

class Ottd < Base
  def initialize
    super
    @tiles = Tiles.new

    start
  end

  def draw
    @tiles.draw
    show_fps
  end

  def mouse_handler(button, state, x, y)
    p @tiles.get_tile_coordinates_of_position(x,y)
  end

end

Ottd.new
