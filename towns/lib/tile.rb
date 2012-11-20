class Tile
  attr_reader :occupation
  attr_accessor :position

  def self.looks_like(*args)
    @sprite = Sprite.find(*args)
    @dimensions = args[3..4]
  end

  def self.sprite
    @sprite
  end

  def occupation=(occupation)
    occupation.tile = self
    @occupation = occupation
  end

  def draw(position)
    self.class.draw(position)
    occupation.draw(position) if occupation
  end

  def self.draw(position)
    Walker::Base.driver.draw.tile(position: position, dimensions: @dimensions, texture: sprite.texture_id)
  end
end

require_relative 'tiles/grass'
