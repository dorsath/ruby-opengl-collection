class Tile
  def initialize(given_x,given_y)
    color = [rand, rand, rand]
    x = (-given_y * 50 + given_x * 50)
    y = (-given_y * 50 + -given_x * 50)

    y *=  0.5 * Math.sqrt(2)
    glPushMatrix
    glTranslate(320, 480, 0)
    x2 = x + 50
    x3 = x - 50
    y2 = y - 50 * r2
    y3 = y - 100 * r2

    glColor(*color)
    glBegin(GL_QUADS) do
      glVertex(x ,y ,0)
      glVertex(x2,y2 ,0)
      glVertex(x ,y3,0)
      glVertex(x3,y2,0)
    end
    glPopMatrix
  end

  def r2
    0.5 * Math.sqrt(2)
  end

end
