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
  end

  def mouse_movement_handler(x,y)
    tile = @tiles.get_tile_from_absolute(x,y)
    @tiles.highlight_tile(tile)
  end

end

Ottd.new
