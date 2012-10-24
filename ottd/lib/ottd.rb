require_relative 'base'
require_relative 'tiles'

class Ottd < Base
  def initialize
    super
    @tiles = Tiles.new

    start
  end

  def draw
    @tiles.draw
    show_fps
  end
end

Ottd.new
