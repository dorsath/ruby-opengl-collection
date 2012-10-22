class TextureLoader
  def self.load(filename)
    source = Magick::ImageList.new(File.expand_path(filename, __FILE__))
    image = source.to_blob do |i|
      i.format = "RGBA"
      i.depth = 8
    end

    texture = glGenTextures(1)[0]

    glBindTexture GL_TEXTURE_2D, texture
    glTexImage2D GL_TEXTURE_2D, 0, GL_RGBA, source.rows, source.columns, 0, GL_RGBA, GL_UNSIGNED_BYTE, image
    glTexParameteri GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR
    glTexParameteri GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR

    texture
  end
end
