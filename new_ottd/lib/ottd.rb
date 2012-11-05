require_relative 'base'
require_relative 'grid'
require_relative 'tile'

class Ottd < Base

  def handle_keyboard(keys)
  end

  def handle_single_keyboard(key)
    exit_game if key == 27
  end
end

game = Ottd.new
grid = Grid.new

10.times do |x|
  10.times do |y|
    grid.set_tile(Tile.new, x, y)
  end
end

game.add_draw_item(grid)

game.start
