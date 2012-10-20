class Character
  def initialize(name)
    @name = name
    @position = [1,1]
  end

  def draw
    glPushMatrix
    glTranslate(*@position,0.1)
    glEnable GL_TEXTURE_2D
    glBindTexture GL_TEXTURE_2D, $sprites[0,0]
    glBegin GL_QUADS do

      glTexCoord2d 0, 1
      glVertex(0,0,0)
      glTexCoord2d 0, 0
      glVertex(0,1,0)
      glTexCoord2d 1, 0
      glVertex(1,1,0)
      glTexCoord2d 1, 1
      glVertex(1,0,0)
    end
    glPopMatrix

    glDisable GL_TEXTURE_2D
  end

  def move_up
    @position[1] += 1
  end

  def move_down
    @position[1] -= 1
  end

  def move_left
    @position[0] -= 1
  end

  def move_right
    @position[0] += 1
  end
end
