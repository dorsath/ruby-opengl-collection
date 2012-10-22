class Level
  attr_reader :game

  INVADER_SPACING = 20
  INVADER_OFFSET = 50
  INVADER_SPEED = 100

  def initialize(aliens, game)
    @aliens = aliens
    @game = game
    @alien_lists = []

    load_textures
    create_enemies_lists

    @block_x = 0
    @block_y = 100
    @direction = 1
    @direction_change_time = game.time
  end

  def load_textures
    @alien_textures = (0..2).map do |id|
      TextureLoader.load("../../alien#{id + 1}.png")
    end
  end

  def draw
    draw_aliens
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

  def draw_aliens
    block_width = ((@aliens.length - 1) * INVADER_SPACING + (@aliens.length * 15))

    if (block_width + @block_x + 2 * INVADER_OFFSET > 640 || @block_x < 0)  && time_since_direction_change > 1
      @direction *= -1
      # @block_y += 20
      @move_down = true
      @direction_change_time = game.time
    end

    if @move_down
      @block_y += INVADER_SPEED * game.dt
      if time_since_direction_change > (20 / INVADER_SPEED.to_f)
        @move_down = false
      end
    else
      @block_x += INVADER_SPEED * game.dt * @direction
    end

    @aliens.each_with_index do |alien, index|
      draw_alien(alien, alien_position(alien,index), @block_y) if alien
    end
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

  def alien_position(alien, index)
    @block_x + INVADER_OFFSET + (index * (15 + INVADER_SPACING)) - 7.5
  end

  def bullet_vs_aliens(bullets)
    bullets.select do |firing_time, bullet_x|
      hit = false
      bullet_y = game.bullet_position(firing_time)

      if (bullet_y - @block_y).abs < 20
        @aliens.each_with_index do |alien, index|
          if alien && (bullet_x - alien_position(alien, index)).abs < 7.5
            @aliens[index] = nil
            hit = true
            game.score += 1
          end
        end
      end

      hit
    end
  end
end
