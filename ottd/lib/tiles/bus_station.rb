class BusStation < Road
  def initialize(x = 0, y = 0, tiles = nil)
    super
    @sprite = Sprite.load("bus_stations/busstation_sl.png", 1, 1)
  end

  def sprite_based_on_adjacent_tiles(tiles)
    case(tiles.map { |d| d.is_a?(Road)})
    when [true, false, false, false], [true, false, true, false], [false, false, true, false]
      @sprite = Sprite.load("bus_stations/busstation_sl.png", 1, 1)
    when [false, true, false, false], [false, true, false, true], [false, false, false, true]
      @sprite = Sprite.load("bus_stations/busstation_sr.png", 1, 1)
    end
  end
end
