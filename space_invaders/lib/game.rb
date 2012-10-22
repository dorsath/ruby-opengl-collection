class Game

  attr_accessor :space_invaders, :score

  SPEED = 100
  SHOTS_PER_MINUTE = 120
  BULLET_SPEED = 200

  def initialize(space_invaders)
    @space_invaders = space_invaders
    @x = 280
    @score = 0
    @active_keys = {}
    @last_time = time
    @last_shot = time
    @bullet_list = nil
    @bullets = {}
  end

  def load
    load_textures

    create_bullet_list
  end

  def load_textures
    source = Magick::ImageList.new(File.expand_path('../../canon.png', __FILE__))
    image = source.to_blob do |i|
      i.format = "RGBA"
      i.depth = 8
    end

    @texture = glGenTextures(1)[0]

    glBindTexture GL_TEXTURE_2D, @texture
    glTexImage2D GL_TEXTURE_2D, 0, GL_RGBA, source.rows, source.columns, 0, GL_RGBA, GL_UNSIGNED_BYTE, image
    glTexParameteri GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR
    glTexParameteri GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR
  end

  def create_bullet_list
    @bullet_list = glGenLists(1)
    glNewList(@bullet_list, GL_COMPILE)
    glBegin(GL_QUADS) do
      glColor(0,1,0)
      glVertex(0,10,0)
      glVertex(1,10,0)
      glVertex(1,0,0)
      glVertex(0,0,0)
    end
    glEndList
  end

  def dt
    time - @last_time
  end

  def keyboard(key)
    case key
    when 27
      space_invaders.show_menu = true
    end
  end

  def handle_keys(keys)
    keys.each do |key, value|
      case key
      when 100
        move_left
      when 102
        move_right
      when 32
        shoot
      end
    end
  end

  def draw
    list_score
    draw_canon
    draw_bullets

    @last_time = time
  end

  def draw_bullets
    glLoadIdentity
    @bullets.each do |firing_time, position|
      glPushMatrix
      glTranslate(position, bullet_position(firing_time), 0)
      glCallList(@bullet_list)
      glPopMatrix
    end

    @bullets = @bullets.reject{ |firing_time, position| bullet_position(firing_time) < 0 }
  end

  def bullet_position(firing_time)
    300 - ((time - firing_time) * BULLET_SPEED)
  end

  def draw_canon
    glLoadIdentity
    glTranslate(@x,300,0)
    glEnable GL_TEXTURE_2D
    glBindTexture(GL_TEXTURE_2D, @texture)
    glBegin(GL_QUADS) do

      glTexCoord2d(0, 0)
      glVertex(0, 0)
      glTexCoord2d(1, 0)
      glVertex(13, 0)
      glTexCoord2d(1, 1)
      glVertex(13, 13)
      glTexCoord2d(0, 1)
      glVertex(0, 13)
    end

    glTranslate(15,0,0)
    glDisable GL_TEXTURE_2D
  end

  def shoot
    if (time - @last_shot) > (60 / SHOTS_PER_MINUTE.to_f)
      @bullets[time] = @x
      @last_shot = time
    end
  end

  def time
    Time.now.to_f
  end

  def move_left
    @x -= SPEED * dt
  end

  def move_right
    @x += SPEED * dt
  end

  def high_score
    9001
  end

  def list_score
    $font.print("SCORE <#{score}>", 0, 0)
    $font.print("HI-SCORE <#{high_score}>", 640, 0, :right)
  end

end
