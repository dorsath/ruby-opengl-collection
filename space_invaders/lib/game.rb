require_relative 'level'

class Game

  attr_accessor :space_invaders, :score, :pauze_time

  SPEED = 100
  SHOTS_PER_MINUTE = 120
  BULLET_SPEED = 300
  CANON_HEIGHT = 400

  def initialize(space_invaders)
    @space_invaders = space_invaders
    @time_offset = 0.0
    @x = 280
    @score = 0
    @active_keys = {}
    @last_time = time
    @last_shot = time
    @bullet_list = nil
    @bullets = {}
    @started = false

    @levels = [
      [2,2,2,2,2,2,2,2,2],
      [1,1,1,1,1,1,1,1,1],
      [0,0,0,0,0,0,0,0,0]
    ]
  end

  def started?
    @started
  end

  def start
    @started = true
    @start_time = time
    @score = 0
    @bullets = {}

    start_level
  end

  def next_level
    start_level(@level_nr + 1)
  end

  def start_level(level = 0)
    @level_nr = level
    @level = Level.new(@levels[level], self)
  end
  
  def load
    load_textures

    create_bullet_list
  end

  def load_textures
    @canon  = TextureLoader.load('../../canon.png')
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
      pauze
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

  def pauze
    @pauze_time = time
  end

  def continue
    @time_offset = pauze_time - time
  end

  def draw
    list_score
    show_time
    draw_canon
    draw_bullets
    @level.draw

    @last_time = time
  end

  

  def show_time
    time_played = (time - @start_time).to_i
    $font.print("Time played <#{(time_played/60).to_i}:#{(time_played%60).to_i}>",0,464)
  end

  def draw_bullets
    check_bullet_hits


    glLoadIdentity
    @bullets.each do |firing_time, position|
      glPushMatrix
      glTranslate(position + 6, bullet_position(firing_time), 0)
      glCallList(@bullet_list)
      glPopMatrix
    end

    @bullets = @bullets.reject{ |firing_time, position| bullet_position(firing_time) < 0 }
  end

  def check_bullet_hits
    @level.bullet_vs_aliens(@bullets).each do |firing_time, position|
      @bullets.delete(firing_time)
    end
  end

  def bullet_position(firing_time)
    CANON_HEIGHT - ((time - firing_time) * BULLET_SPEED)
  end

  def draw_canon
    glLoadIdentity
    glTranslate(@x,CANON_HEIGHT,0)
    glEnable GL_TEXTURE_2D
    glBindTexture(GL_TEXTURE_2D, @canon)
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
    Time.now.to_f + @time_offset
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
