require_relative 'base'
require_relative 'tiles'

class Ottd < Base
  def initialize
    @tiles = Tiles.new
    super
  end

  def draw
    @tiles.draw
    show_fps
  end
end

Ottd.new
