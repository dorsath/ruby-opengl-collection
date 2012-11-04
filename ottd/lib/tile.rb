class Tile
  attr_reader :x, :y
  attr_accessor :highlight, :sprite

  def initialize(x = 0, y =0, tiles = nil)
    @x, @y = x, y
    @highlight = false
  end

  def draw
    @sprite.draw(x,y) do |sprite|
      sprite.draw_highlight if @highlight
    end
  end

  def position
    [x,y]
  end

  def adjacent_tiles
    adjacent_offsets = [ [-1,0], [0, -1], [1, 0], [0, 1] ]

    adjacent_offsets.map do |offsets|
      tiles.get_tile(@x + offsets[0], @y + offsets[1])
    end
  end
end
