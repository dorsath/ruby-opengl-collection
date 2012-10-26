class Tile
  attr_reader :x, :y
  attr_accessor :highlight, :sprite

  def initialize(x = 0, y =0)
    @x, @y = x, y
    @highlight = false
  end

  def draw
    @sprite.draw(@x,@y) do |sprite|
      sprite.draw_highlight if @highlight
    end
  end

end
