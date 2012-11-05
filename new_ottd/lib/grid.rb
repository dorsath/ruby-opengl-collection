class Grid
  TILE_SIZE = 32

  def initialize
    @grid = {}
  end

  def draw
    @grid.each do |position, tile|
      GL.Translate(0,0,0)
      tile.draw
    end
  end

  def set_tile(tile, *position)
    tile.position = position

    @grid[position] = tile
  end

  def get_tile(*position)
    @grid[position]
  end

  def grid_position_from_coordinates(x, y)
    x = 320 - x
    y = 480 - y

    _x = (y/32.0 + x/64.0).floor
    _y = (-x/64.0 + y/32.0).floor

    [_x,_y]
  end

  def screen_coordinate_from_position(x, y)
    [320 + TILE_SIZE * -x + TILE_SIZE * y, 480 + (TILE_SIZE * -x + TILE_SIZE * -y) * 0.5]
  end
end
