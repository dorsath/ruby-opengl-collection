class Game

  attr_accessor :space_invaders, :score

  SPEED = 100
  SHOTS_PER_MINUTE = 60

  def initialize(space_invaders)
    @space_invaders = space_invaders
    @x = 0
    @score = 0
    @active_keys = {}
    @last_time = Time.now.to_f
    @last_shot = Time.now.to_f
  end

  def load
    load_textures
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

  def dt
    Time.now.to_f - @last_time
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
    @last_time = Time.now.to_f
  end

  def draw_canon
    glLoadIdentity
    glTranslate(280 + @x,300,0)
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
    if (Time.now.to_f - @last_shot) > (SHOTS_PER_MINUTE / 60.0)
      @score += 1 
      @last_shot = Time.now.to_f
    end
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
