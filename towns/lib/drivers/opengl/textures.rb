module Opengl
  class Textures
    def self.register(texture)
      texture_id = glGenTextures(1)[0]

      image_data = texture.to_blob do |i|
        i.format = "RGBA"
        i.depth = 8
      end

      glBindTexture GL_TEXTURE_2D, texture_id
      glTexImage2D GL_TEXTURE_2D, 0, GL_RGBA, texture.columns, texture.rows, 0, GL_RGBA, GL_UNSIGNED_BYTE, image_data
      glTexParameteri GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR
      glTexParameteri GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR

      texture_id
    end

  end
end
