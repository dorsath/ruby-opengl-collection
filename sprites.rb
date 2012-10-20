require 'RMagick'

class Sprites
  include Magick
  include GL

  TILE_SIZE = 16

  def initialize
    @source = Magick::ImageList.new(File.expand_path('../sprites.png', __FILE__))
    @textures = {}
  end

  def [](x,y)
    (@textures[pointer(x,y)] || load_texture(x,y))[0]
  end

  def pointer(x,y)
     "#{x}x#{y}"
  end

  def load_texture(x,y)
    puts "loading #{x}x#{y}"

    texture = Magick::Image.new(TILE_SIZE, TILE_SIZE).composite(tile(x,y), 0, 0, Magick::OverCompositeOp)

    image = texture.to_blob do |i|
      i.format = "RGBA"
      i.depth = 8
    end

    @textures[pointer(x,y)] = glGenTextures 1

    glBindTexture GL_TEXTURE_2D, @textures[pointer(x,y)][0]
    glTexImage2D GL_TEXTURE_2D, 0, GL_RGBA, texture.rows, texture.columns, 0, GL_RGBA, GL_UNSIGNED_BYTE, image
    glTexParameteri GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR
    glTexParameteri GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR

    @textures[pointer(x,y)]
  end

  def tile(x,y)
    x = (x * TILE_SIZE) + x
    y = (y * TILE_SIZE) + y

    @source.crop(x,y,TILE_SIZE,TILE_SIZE)
  end


end

  
