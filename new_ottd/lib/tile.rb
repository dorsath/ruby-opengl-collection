class Tile
  attr_accessor :position, :occupation

  def draw
    glColor(1,0,0)
    glBegin(GL_QUADS) do
      glVertex(0,0,0)
      glVertex(-32,-16,0)
      glVertex(0,-32,0)
      glVertex(32,-16,0)
    end
  end
end
