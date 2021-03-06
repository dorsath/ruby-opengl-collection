require 'rmagick'

class Texture
  TILE_SIZE = 32

  attr_reader :dimensions, :source_path, :texture_id, :tile_list_id, :source_dimensions

  def initialize(source_path)
    @dimensions = [1,1]
    @source_path = source_path

    @texture_id   = load_texture
    @tile_list_id = load_list
  end

  def draw
    glEnable(GL_TEXTURE_2D)
    glCallList(tile_list_id)
    glDisable(GL_TEXTURE_2D)
  end

  def self.load(source_path)
    @@textures ||= {}

    @@textures[source_path] ||= Texture.new(source_path)
  end

  def self.textures
    @@textures
  end

  def load_texture
    source = Magick::ImageList.new(File.expand_path("../../textures/#{source_path}", __FILE__))
    @source_dimensions = [source.columns.to_f, source.rows.to_f]

    transparent_pixel = Magick::Pixel.new
    transparent_pixel.opacity = 65408


    source.first.each_pixel do |pixel, x, y|
      if pixel.hash == 65408
        source.first.store_pixels(x,y,1,1, [transparent_pixel])
      end
    end

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

  def load_list
    x, y = dimensions
    width, height  =  source_dimensions

    tile_list = glGenLists(1)
    glNewList(tile_list, GL_COMPILE)

    # these are relative to x,y with the axis as down == positive the tile 
    #  x1,y2---x3,y2
    #    |      |
    #    |      x3,y3
    #  x1,y1   /
    #     \   /
    #      x,y

    x0 = 0
    y0 = 0
    x1 = TILE_SIZE * -x
    y1 = TILE_SIZE * -x * r2
    x3 = TILE_SIZE *  y
    y3 = TILE_SIZE * -y * r2
    y2 = -height

    tx0 = x1.abs/width
    ty1 = 1 - y1.abs/height
    ty3 = 1 - y3.abs/height

    glBindTexture(GL_TEXTURE_2D, @texture_id)
    glColor(1,1,1)
    # glBegin(GL_LINE_LOOP) do
    glBegin(GL_POLYGON) do

      glTexCoord2d(tx0,1)
      glVertex(x0, y0)

      glTexCoord2d(0,ty1)
      glVertex(x1, y1)

      glTexCoord2d(0,0)
      glVertex(x1, y2)

      glTexCoord2d(1,0)
      glVertex(x3, y2)

      glTexCoord2d(1,ty3)
      glVertex(x3, y3)
    end

    glEndList

    tile_list
  end

  def r2
    0.5
  end

end
