class Character
  def initialize(name)
    @name = name
    @x, @y = 0, 0

  end

  def draw
    glPushMatrix
    glScale(50,50,50)
    glEnable GL_TEXTURE_2D
    glTranslate(@x,@y,0)
    $sprites[4,0]
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
