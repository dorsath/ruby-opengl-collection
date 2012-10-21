require 'RMagick'

class Sprites
  include Magick
  include GL

  TILE_SIZE = 16

  def initialize
    @source = Magick::ImageList.new(File.expand_path('../sprites.bmp', __FILE__))
    @textures = {}
    @lists = {}
    @base = 0
  end

  def [](x,y)
    if @textures[pointer(x,y)].nil?
      texture = load_texture(x,y)
      create_list(x,y)
    end

    glCallList(@lists[pointer(x,y)])
  end

  def pointer(x,y)
     "#{x}x#{y}"
  end

  def load_texture(x,y)
    texture = Magick::Image.new(TILE_SIZE, TILE_SIZE).composite(new_tile(x,y), 0, 0, Magick::OverCompositeOp)
    texture.transparent_color = 'white'
        

    image = texture.to_blob do |i|
      i.format = "RGBA"
      i.depth = 8
    end

    @textures[pointer(x,y)] = glGenTextures(1)[0]

    glBindTexture GL_TEXTURE_2D, @textures[pointer(x,y)]
    glTexImage2D GL_TEXTURE_2D, 0, GL_RGBA, texture.rows, texture.columns, 0, GL_RGBA, GL_UNSIGNED_BYTE, image
    glTexParameteri GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR
    glTexParameteri GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR

    @textures[pointer(x,y)]
  end

  def new_tile(x,y)
    x = (x * TILE_SIZE) + x
    y = (y * TILE_SIZE) + y

    @source.crop(x,y,TILE_SIZE,TILE_SIZE)
  end

  def create_list(x,y)
    @lists[pointer(x,y)] = glGenLists(1)
    glNewList(@lists[pointer(x,y)], GL_COMPILE)
    glBindTexture(GL_TEXTURE_2D, @textures[pointer(x,y)])
    glBegin GL_QUADS do
      glTexCoord2d 0, 0
      glVertex(0,0,0)
      glTexCoord2d 0, 1
      glVertex(0,1,0)
      glTexCoord2d 1, 1
      glVertex(1,1,0)
      glTexCoord2d 1, 0
      glVertex(1,0,0)
    end
    glEndList
  end


end

  
