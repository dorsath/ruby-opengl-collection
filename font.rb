require 'RMagick'

class Font
  include Magick
  include GL

  TILE_SIZE = 16

  def initialize
    @source = Magick::ImageList.new(File.expand_path('../Font.bmp', __FILE__))
    @base = 0
    @texture = nil
  end

  def print(text, x=0, y=0)
    glLoadIdentity
    glTranslate(x,y,0)
    glEnable GL_TEXTURE_2D

    glEnable GL_BLEND
    bytes = []
    text.each_byte do |c|
      bytes << @base + c - 32 #32 offset
    end
    glCallLists(UNSIGNED_BYTE, bytes)
    glDisable GL_BLEND

    glDisable GL_TEXTURE_2D
  end

  def pointer(x,y)
     "#{x}x#{y}"
  end

  def load
    load_texture

    load_lists
  end

  def load_texture
    image = @source.to_blob do |i|
      i.format = "RGBA"
      i.depth = 8
    end

    @texture = glGenTextures(1)[0]

    glBindTexture GL_TEXTURE_2D, @texture
    glTexImage2D GL_TEXTURE_2D, 0, GL_RGBA, @source.rows, @source.columns, 0, GL_RGBA, GL_UNSIGNED_BYTE, image
    glTexParameteri GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR
    glTexParameteri GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR
  end

  def load_lists
    @base = glGenLists(256)
    256.times do |list_id|
      x1 = (list_id%16)/16.0
      y1 = (list_id/16.0).floor/16.0
      x2 = x1 + 16/256.0
      y2 = y1 + 16/256.0

      glNewList(@base + list_id, GL_COMPILE)
      glBindTexture(GL_TEXTURE_2D, @texture)
      glBegin(GL_QUADS) do

        glTexCoord2d(x1, y2)
        glVertex(0, TILE_SIZE)
        glTexCoord2d(x2, y2)
        glVertex(TILE_SIZE, TILE_SIZE)
        glTexCoord2d(x2, y1)
        glVertex(TILE_SIZE, 0)
        glTexCoord2d(x1, y1)
        glVertex(0, 0)
      end

      glTranslate(15,0,0)
      glEndList
    end
  end
end
