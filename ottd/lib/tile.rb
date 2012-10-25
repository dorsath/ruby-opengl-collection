class Tile
  attr_reader :x, :y, :sprite
  attr_accessor :highlight

  def initialize(sprite, x, y)
    @sprite, @x, @y = sprite, x, y
    @highlight = false
  end

  def draw
    @sprite.draw(@x,@y) do
      draw_highlight if @highlight
    end
  end

  def draw_highlight
    glBegin(GL_LINE_LOOP) do
      glVertex(0,0)
      glVertex(-32,-16)
      glVertex(0, -32)
      glVertex( 32, -16)
    end
  end
end
