module Opengl
  class Draw
    def self.tile(options)
      w, h = options[:dimensions]
      glPushMatrix
      glTranslate(*options[:position], 0)
      glEnable GL_TEXTURE_2D
      glBlendFunc(GL_SRC_ALPHA,GL_ONE_MINUS_SRC_ALPHA)
      glEnable(GL_BLEND)
      glBindTexture(GL_TEXTURE_2D, options[:texture])

      y1 = (1 - 16.0/h)

      glBegin(GL_POLYGON) do

        glTexCoord2d(0.5, 1) ; glVertex(  0,  0, 0)
        glTexCoord2d(  0, y1); glVertex(-32,-16, 0)
        glTexCoord2d(  0, 0) ; glVertex(-32, -h, 0)
        glTexCoord2d(  1, 0) ; glVertex( 32, -h, 0)
        glTexCoord2d(  1, y1); glVertex( 32,-16, 0)
      end

      glDisable GL_TEXTURE_2D
      glDisable GL_BLEND 
      glPopMatrix
    end

    def self.button(options)
      glPushMatrix
      offset = options[:location].map(&:min)
      w, h   = options[:location].map(&:max)


      glEnable GL_TEXTURE_2D
      glEnable(GL_BLEND)
      if options[:background]
        glBindTexture(GL_TEXTURE_2D, options[:background].texture_id)

        glTranslate(*offset, 0)
        glBegin(GL_QUADS) do
          glTexCoord2d(0, 0); glVertex(0, 0, 0)
          glTexCoord2d(1, 0); glVertex(w, 0, 0)
          glTexCoord2d(1, 1); glVertex(w, h, 0)
          glTexCoord2d(0, 1); glVertex(0, h, 0)
        end
      end

      glBindTexture(GL_TEXTURE_2D, options[:texture].texture_id)
      glTranslate(*offset, 0)
      glBegin(GL_QUADS) do
        glTexCoord2d(0, 0); glVertex(0, 0, 0)
        glTexCoord2d(1, 0); glVertex(w, 0, 0)
        glTexCoord2d(1, 1); glVertex(w, h, 0)
        glTexCoord2d(0, 1); glVertex(0, h, 0)
      end

      glDisable GL_TEXTURE_2D
      glDisable GL_BLEND 
      glPopMatrix
    end

    def self.citizen(options)
      w, h = 40, 40
      position = options[:position]

      glPushMatrix
      glTranslate(position[0] + 8, position[1] - 3, 0)
      glBindTexture(GL_TEXTURE_2D, options[:texture].texture_id)
      glEnable GL_TEXTURE_2D
      glEnable(GL_BLEND)
      glBegin(GL_QUADS) do
        glTexCoord2d(0, 0); glVertex(0, 0, 0)
        glTexCoord2d(1, 0); glVertex(w, 0, 0)
        glTexCoord2d(1, 1); glVertex(w, h, 0)
        glTexCoord2d(0, 1); glVertex(0, h, 0)
      end
      glDisable GL_TEXTURE_2D
      glDisable GL_BLEND 
      glPopMatrix
    end
  end

end
