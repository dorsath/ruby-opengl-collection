class Tile
  attr_reader :x, :y, :sprite
  attr_accessor :highlight

  def initialize(sprite, x, y)
    @sprite, @x, @y = sprite, x, y
    @highlight = false
  end

  def draw
    @sprite.draw(@x,@y) do |sprite|
      sprite.draw_highlight if @highlight
    end
  end

end
