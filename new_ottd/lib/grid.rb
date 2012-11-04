class Grid
  def initialize
    @grid = {}
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
end
