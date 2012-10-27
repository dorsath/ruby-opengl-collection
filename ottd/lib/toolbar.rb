class Toolbar
  TILE_SIZE = 64

  attr_reader :items, :current_tool

  def initialize(items)
    @items = items.map(&:new)
    @button = load("button.png")
    @current_tool = nil

  end

  def draw
    glTranslate(100,0,0)
    glEnable(GL_TEXTURE_2D)

    @items.each do |item|
      glCallList(@button)
      glTranslate(32,32,0)
      glEnable(GL_BLEND)
      glCallList(item.sprite.tile_list)
      glDisable(GL_BLEND)
      glTranslate(32,-32,0)
    end

    glDisable(GL_TEXTURE_2D)
  end

  def select_tool(x,y)
    if y < 32 && x > 100 && x < @items.length * TILE_SIZE  + 100
      @current_tool = @items[((x - 100)/TILE_SIZE.to_f).floor].class
    end
  end

  def load(image_path)
    load_list(load_texture(image_path))
  end

  def load_list(texture)
    list = glGenLists(1)

    glNewList(list, GL_COMPILE)
    glBindTexture(GL_TEXTURE_2D, texture)
    glBegin(GL_QUADS) do

      glTexCoord2d(0, 1)
      glVertex(0, TILE_SIZE/2)
      glTexCoord2d(1, 1)
      glVertex(TILE_SIZE, TILE_SIZE/2)
      glTexCoord2d(1, 0)
      glVertex(TILE_SIZE, 0)
      glTexCoord2d(0, 0)
      glVertex(0, 0)
    end
    glEndList

    list
  end

  def load_texture(image_file)
    source = Magick::ImageList.new(File.expand_path("../../textures/#{image_file}", __FILE__))

    image_data = source.to_blob do |i|
      i.format = "RGBA"
      i.depth = 8
    end

    texture = glGenTextures(1)[0]

    glBindTexture GL_TEXTURE_2D, texture
    glTexImage2D GL_TEXTURE_2D, 0, GL_RGBA, source.columns, source.rows, 0, GL_RGBA, GL_UNSIGNED_BYTE, image_data
    glTexParameteri GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR
    glTexParameteri GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR
    
    texture
  end

end
