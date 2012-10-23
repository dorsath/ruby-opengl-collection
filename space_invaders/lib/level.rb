class Level
  attr_reader :game

  INVADER_SPACING = 20
  INVADER_OFFSET = 50
  INVADER_SPEED = 100
  BOMBS_PER_MINUTE = 60
  BOMB_VELOCITY = 100

  def initialize(aliens, game)
    @aliens = aliens.to_enum(:each_with_index).map { |alien, position| {position: position, type: alien }}

    @game = game
    @alien_lists = []

    load_textures
    create_enemies_lists
    create_bomb_list

    @block_x = 0
    @block_y = 100
    @direction = 1
    @bombs = []
    @direction_change_time = game.time
    @last_bomb = game.time
  end


  def load_textures
    @alien_textures = (0..2).map do |id|
      TextureLoader.load("../../alien#{id + 1}.png")
    end
  end

  def draw
    game.next_level if @aliens.compact.empty?

    draw_aliens
    draw_bombs
    check_bomb_hits

    alien_bombs
  end

  def create_enemies_lists
    base = glGenLists(3)
    @alien_lists = (0..2).map do |id|
      glNewList(base + id, GL_COMPILE)
      glBindTexture(GL_TEXTURE_2D, @alien_textures[id])
      glBegin(GL_QUADS) do
        glColor(1,1,1)
        glTexCoord2d(0, 0)
        glVertex(0, 0)
        glTexCoord2d(1, 0)
        glVertex(15, 0)
        glTexCoord2d(1, 1)
        glVertex(15, 15)
        glTexCoord2d(0, 1)
        glVertex(0, 15)
      end
      glEndList

      base + id
    end
  end

  def create_bomb_list
    @bomb_list = glGenLists(1)
    glNewList(@bomb_list, GL_COMPILE)
    glBegin(GL_QUADS) do
      glColor(1,1,1)
      glVertex(0,10,0)
      glVertex(1,10,0)
      glVertex(1,0,0)
      glVertex(0,0,0)
    end
    glEndList
  end

  def aliens_left
    @aliens.compact
  end

  def alien_bombs
    if (game.time - @last_bomb) > (60/ BOMBS_PER_MINUTE.to_f)
      bombing_alien = aliens_left[rand(0..(aliens_left.length - 1))]
      @bombs << [alien_position(bombing_alien), @block_y + 15]
      @last_bomb = game.time
    end
  end

  def draw_bombs
    @bombs.each do |bomb|
      glLoadIdentity
      bomb[1] += BOMB_VELOCITY * game.dt
      glTranslate(bomb[0] + 7.5, bomb[1], 0)
      glCallList(@bomb_list)
    end

    @bombs = @bombs.reject { |bomb| bomb[1] > 480 }
  end

  def draw_aliens
    if (block_width + @block_x + 2 * INVADER_OFFSET > 640 || @block_x < 0)  && time_since_direction_change > 1
      @direction *= -1
      @move_down = true
      @direction_change_time = game.time
    end

    if @move_down
      @block_y += invader_speed * game.dt
      if time_since_direction_change > (20 / invader_speed.to_f)
        @move_down = false
      end
    else
      @block_x += invader_speed * game.dt * @direction
    end

    @aliens.each do |alien|
      draw_alien(alien[:type], alien_position(alien), @block_y) if alien
    end
  end

  def block_width
    ((@aliens.length - 1) * INVADER_SPACING + (@aliens.length * 15))
  end

  def time_since_direction_change
    game.time - @direction_change_time
  end

  def draw_alien(id,x,y)
    glLoadIdentity
    glTranslate(x,y,0)
    glEnable GL_TEXTURE_2D
    glCallList(@alien_lists[id])
    glDisable GL_TEXTURE_2D
  end

  def alien_position(alien)
    position = alien[:position] - (alien[:position] - @aliens.index(alien))
    @block_x + INVADER_OFFSET + (position * (15 + INVADER_SPACING)) - 7.5
  end

  def bullet_vs_aliens(bullets)
    hit_bullets = bullets.select do |firing_time, bullet_x|
      hit = false
      bullet_y = game.bullet_position(firing_time)

      if (bullet_y - @block_y).abs < 20
        @aliens.each_with_index do |alien, index|
          if alien && (bullet_x - alien_position(alien)).abs < 7.5
            @aliens[index] = nil
            hit = true
            game.score += 1
          end
        end
      end

      hit
    end

    refit_alien_array

    hit_bullets
  end

  def check_bomb_hits
    @bombs.each do |bomb|
      game.died if ((bomb[1] - Game::CANON_HEIGHT).abs < 10 && (game.x - bomb[0]).abs < 10)
    end
  end

  def refit_alien_array
    while @aliens.first.nil? && @aliens.any?
      @aliens.delete_at(0)
      @block_x += INVADER_SPACING + 15
    end

    while @aliens.last.nil? && @aliens.any?
      @aliens.delete_at(@aliens.length - 1)
    end
  end

  def invader_speed
    multiplyer = case aliens_left.length
    when 1
      3
    when (2..4)
      2
    else
      1
    end
    INVADER_SPEED * multiplyer
  end
end
