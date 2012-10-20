class World
  def initialize
    load_world
  end

  def map_layout
   "ghhhggggg
    ghhhggggg
    ghhhggggg
    ggggggggg"
  end

  def load_world
    @map = map_layout.gsub(' ', '').split(//).map { |tile| translate(tile) }
  end
  
  def draw
    x = 0
    @map.each do |tile|
      if tile.nil?
        glTranslate(-x,-1, 0)
        x = 0
      else
        glTranslate(1,0,0)
        draw_tile($sprites[*tile])
        x += 1
      end
    end
  end

  def translate(sign)
    case sign
    when "g"
      [3,3]
    when "h"
      [35,2]
    end
  end

  def draw_tile(sprite)
    glEnable GL_TEXTURE_2D
    glBindTexture GL_TEXTURE_2D, sprite
    glBegin GL_QUADS do

      glTexCoord2d 0, 1
      glVertex(0,0,0)
      glTexCoord2d 0, 0
      glVertex(0,1,0)
      glTexCoord2d 1, 0
      glVertex(1,1,0)
      glTexCoord2d 1, 1
      glVertex(1,0,0)
    end

    glDisable GL_TEXTURE_2D
  end
end
