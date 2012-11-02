require_relative 'tile'
require_relative 'sprite'

require_relative 'tiles/road'
Dir[File.dirname(__FILE__) + '/tiles/*.rb'].each {|file| require file }


class Tiles

  FORCE_REDRAW_TIME = 0.5

  def initialize(width, height)
    @width, @height = width, height
    @camera = [0,50]
    @zoom = 1
    # @tile = Tile.new
    # @buildings = [
    #   Sprite.new("building1.png", 1,2),
    #   Sprite.new("building2.png", 1,2)
    # ]
    @grass = Grass
    @road  = Road
    @building = Building
    @bus_station = BusStation
    @last_force_redraw_time = time

    @grid = []
    width.times do |x|
      height.times do |y|
        set_tile(@grass,x,y)
      end
    end

    5.times do |x|
      set_tile(@road, x,0)
      set_tile(@building, x, 1)
    end

    initBuffer
    @redraw = true
  end

  def handle_keys(active_keys, dt)
    camera_speed = 500
    if active_keys[100]
      @redraw = true
      @camera[0] += camera_speed * dt
    end
    if active_keys[101]
      @redraw = true
      @camera[1] += camera_speed * dt
    end
    if active_keys[102]
      @redraw = true
      @camera[0] -= camera_speed * dt
    end
    if active_keys[103]
      @redraw = true
      @camera[1] -= camera_speed * dt
    end
  end

  def handle_single_keys(key)
    zoom_stages = [0.25,0.5,1,2]
    case key
    when 45
      @redraw = true
      @zoom = zoom_stages[zoom_stages.index(@zoom) - 1]
    when 61
      @redraw = true
      @zoom = zoom_stages[zoom_stages.index(@zoom) + 1] if zoom_stages.index(@zoom) + 1 < zoom_stages.length
    end
  end

  def handle(button, x, y, tool)
    if tool
      x, y = get_tile_coordinates_of_position(x,y)
      set_tile(tool, x,y)
    end
  end

  def placeable
    [@road, @grass, @building, @bus_station]
  end

  def time
    Time.now.to_f
  end

  def set_tile(tile, x, y)
    if (0..@width).include?(x) && (0..@height).include?(y)
      @grid[x] ||= []
      @grid[x][y] = tile.new(x, y, self)
      @redraw = true
    end
  end

  def draw
    if @redraw
      glBindFramebufferEXT(GL_FRAMEBUFFER_EXT, @screen_buffer)
      glColor(0,0,0)
      glBegin(GL_QUADS) do 
        glVertex(0, 0, 0)
        glVertex(640, 0, 0)
        glVertex(640, 480, 0)
        glVertex(0, 480, 0)
      end

      glTranslate(*@camera, 0)
      glScale(@zoom, @zoom, @zoom)
      @grid.reverse.each_with_index do |row, x|
        row.reverse.each_with_index do |tile, y|
          tile.draw
        end
      end

      @redraw = false

      glBindFramebufferEXT(GL_FRAMEBUFFER_EXT, 0)
    end

    glLoadIdentity
    glEnable GL_TEXTURE_2D
    glBindTexture(GL_TEXTURE_2D, @screen_texture)
    glBegin(GL_QUADS) do 
      glTexCoord2d(0, 1)
      glVertex(0, 0, 0)
      glTexCoord2d(1, 1)
      glVertex(640, 0, 0)
      glTexCoord2d(1, 0)
      glVertex(640, 480, 0)
      glTexCoord2d(0, 0)
      glVertex(0, 480, 0)
    end
    glDisable GL_TEXTURE_2D

    if time - @last_force_redraw_time > FORCE_REDRAW_TIME
      @redraw = true
      @last_force_redraw_time = time
    end
  end

  def initBuffer
    @screen_buffer = glGenFramebuffersEXT(1).first
    @render_buffer = glGenRenderbuffersEXT(1).first
    @screen_texture = glGenTextures(1).first

    glBindFramebufferEXT(GL_FRAMEBUFFER_EXT, @screen_buffer)

    glBindTexture GL_TEXTURE_2D, @screen_texture
    glTexImage2D GL_TEXTURE_2D, 0, GL_RGBA, 640, 480, 0, GL_RGBA, GL_UNSIGNED_BYTE, nil
    glTexParameteri GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR
    glTexParameteri GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR

    glFramebufferTexture2DEXT(GL_FRAMEBUFFER_EXT, GL_COLOR_ATTACHMENT0_EXT, GL_TEXTURE_2D, @screen_texture, 0)
    glBindRenderbufferEXT(GL_RENDERBUFFER_EXT, @render_buffer)
    glRenderbufferStorageEXT(GL_RENDERBUFFER_EXT, GL_DEPTH_COMPONENT24, 640, 480)
    glFramebufferRenderbufferEXT(GL_FRAMEBUFFER_EXT, GL_DEPTH_ATTACHMENT_EXT, GL_RENDERBUFFER_EXT, @render_buffer)

    glBindFramebufferEXT(GL_FRAMEBUFFER_EXT, 0)

    statusFBO
  end

  def statusFBO
    stat = glCheckFramebufferStatusEXT(GL_FRAMEBUFFER_EXT)
    return if (stat==0 || stat == GL_FRAMEBUFFER_COMPLETE_EXT)
    printf("FBO status: %04X\n", stat)
    exit(0)
  end


  def highlight_tile(tile)
    if tile != @last_highlight
      tile.highlight = true if tile
      @last_highlight.highlight = false if @last_highlight

      @last_highlight = tile
    end
  end

  def get_tile(x,y)
    if @grid[x].is_a?(Array)
      @grid[x][y]
    end
  end

  def get_tile_from_absolute(x,y)
    x, y = get_tile_coordinates_of_position(x,y)
    if @grid[x].is_a?(Array) && !@grid[x][y].nil?
      @grid[x][y]
    else
      false
    end
  end

  def get_tile_coordinates_of_position(x,y)
    x = 320 - x + @camera[0]
    y = 480 - y + @camera[1]

    _x = (y/32.0 + x/64.0).floor
    _y = (-x/64.0 + y/32.0).floor

    [_x,_y]
  end
end
