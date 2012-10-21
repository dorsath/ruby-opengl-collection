class Character
  def initialize(name)
    @name = name
    @x, @y = 0, 0

  end

  def draw
    glPushMatrix
    glScale(50,50,50)
    glEnable GL_TEXTURE_2D
    glBindTexture GL_TEXTURE_2D, $sprites[4,0]
    glBegin GL_QUADS do

      glTexCoord2d 0, 0
      glVertex(@x,@y,0)
      glTexCoord2d 0, 1
      glVertex(@x,@y + 1,0)
      glTexCoord2d 1, 1
      glVertex(@x + 1,@y + 1,0)
      glTexCoord2d 1, 0
      glVertex(@x + 1,@y,0)
    end
    glPopMatrix

    glDisable GL_TEXTURE_2D
  end

  def move_up
    @y -= 1
  end

  def move_down
    @y += 1
  end

  def move_left
    @x -= 1
  end

  def move_right
    @x += 1
  end
end
