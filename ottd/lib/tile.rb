class Tile
  attr_reader :x, :y, :sprite

  def initialize(sprite, x, y)
    @sprite, @x, @y = sprite, x, y

  end

  def draw
    return if @hide
    @sprite.draw(@x,@y)
  end

  def toggle_hide
    @hide = !@hide
  end
end
