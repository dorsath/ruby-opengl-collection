require_relative 'base'
require_relative 'tiles'
require_relative 'toolbar'

class Ottd < Base
  def initialize
    super

    @tiles = Tiles.new(64, 64) #size of field
    @toolbar = Toolbar.new(@tiles.placeable)
    start
  end

  def draw
    @tiles.draw
    glLoadIdentity
    @toolbar.draw
    glLoadIdentity
    show_fps

    handle_keys
  end

  def handle_keys
    @tiles.handle_keys(@active_keys, dt)
  end

  def mouse_handler(button, state, x, y)
    @toolbar.select_tool(x,y)
    @tiles.handle(button, x, y, @toolbar.current_tool) if state == 1
  end

  def mouse_movement_handler(x,y)
    tile = @tiles.get_tile_from_absolute(x,y)
    @tiles.highlight_tile(tile)
  end

end

Ottd.new
