require 'rmagick'

class Sprite
  attr_reader :image, :width, :height, :texture_id

  def initialize(image, width, height)
    @image, @width, @height = image, width, height


    @texture_id = Walker::Base.driver.textures.register(image)
  end

  def dimensions
    [width, height]
  end

  def self.find(source_path, x, y, width, height)
    source = load_source(source_path)
    return if source.columns < x + width or source.rows < y + height
    image  = source.crop(x, y, width, height)
    new(image, width, height)
  end

  def self.load_source(source_path)
    Magick::ImageList.new(File.expand_path("../../textures/#{source_path}", __FILE__))
  end

end
