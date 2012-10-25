class Tile
  def initialize
    load
  end

  def draw(x,y)
    color = [rand,rand,rand]

    glPushMatrix
    glTranslate(320, 480, 0)
    glTranslate(50 * -x + 50 * y, (50 * -x + 50 * -y) * r2 , 0)

    glColor(*color)
    glCallList(@tile_list)
    glPopMatrix
  end

  def load
    @tile_list = glGenLists(1)
    glNewList(@tile_list, GL_COMPILE)
    x = 0
    y = 0
    x2 = 50
    x3 = -50
    y2 = -50 * r2
    y3 = -100 * r2

    glBegin(GL_QUADS) do
      glVertex(x ,y ,0)
      glVertex(x2,y2 ,0)
      glVertex(x ,y3,0)
      glVertex(x3,y2,0)
    end

    glEndList
  end

  def r2
    0.5 * Math.sqrt(2)
  end
end
