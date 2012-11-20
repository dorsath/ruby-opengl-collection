class Item
  attr_accessor :tile

  def self.looks_like(*args)
    @sprite = Sprite.find(*args)
    @dimensions = args[3..4]
  end

  def draw(position)
    self.class.draw(position)
  end

  def self.draw(position)
    Walker::Base.driver.draw.tile(position: position, dimensions: @dimensions, texture: sprite.texture_id)
  end

  def self.sprite
    @sprite
  end

end

require_relative 'items/tree'
