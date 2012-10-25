class Tile
  def initialize(image_file, *dimensions)
    load(*dimensions)
  end

  def draw(x = 0,y = 0)
    color = [1,1,1]

    glPushMatrix
    glTranslate(320, 480, 0)
    glTranslate(50 * -x + 50 * y, (50 * -x + 50 * -y) * r2 , 0)

    glColor(*color)
    glCallList(@tile_list)
    glPopMatrix
  end

  def load(x, y)
    @tile_list = glGenLists(1)
    glNewList(@tile_list, GL_COMPILE)


    # these are relative to x,y with the axis as down == positive
    #       x2,y2
    #      /    \
    #     /     x3,y3
    #  x1,y1   /
    #     \   /
    #      x,y

    x0 = 0
    y0 = 0
    x1 = 50 * -x
    y1 = 50 * -x * r2
    x3 = 50 *  y
    y3 = 50 * -y * r2

    x2 = x1 + x3
    y2 = y1 + y3

    glBegin(GL_LINE_LOOP) do
      glVertex(x0, y0)
      glVertex(x1, y1)
      glVertex(x2, y2)
      glVertex(x3, y3)
    end

    glEndList
  end

  #compensation for tilting the z axis 45 degrees
  def r2 
    0.5 * Math.sqrt(2)
  end
end
