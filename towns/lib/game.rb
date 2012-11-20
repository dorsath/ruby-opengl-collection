require_relative 'drivers/opengl'
require_relative 'walker'
require_relative 'hitbox'

class Towns < Walker::Base
  presentation_driver Opengl::Base.new
end

require_relative 'grid'
require_relative 'interface'
require_relative 'sprite'
require_relative 'tile'
require_relative 'item'
require_relative 'population'
require_relative 'citizen'

class Towns < Walker::Base
  def game
    @grid = Grid.new
    10.times do |x|
      10.times do |y|
        @grid.set_tile(Grass.new, 9 -x, 9 -y)
      end
    end
    @grid.get_tile(1,1).occupation = Tree.new

    @interface = Interface.new
    @interface.add_button(->{@grid.active_tool = Tree}, {location: [0..60,0..60], texture: Sprite.find("ui.png", 130, 737, 60, 60), hitbox: Hitbox.circle(coordinates: [30, 30], distance: 30)})

    @population = Population.new(grid: @grid)
    citizen = @population.new_citizen(position: [7,1])

    citizen.move_towards [5, 2]


    add(@grid)
    add(@interface)
    add(@population)
  end

end


towns = Towns.new



    # @grid.get_tile(1,1).occupation = Tree.new
    # @interface.add_action(->(x,y){@grid.set_tile(Tree, *@grid.grid_position_from_coordinates(x,y))}, [0..50,0..50])

    # # @grid.set_tile(Tree.new, 0, 0)

    # $driver.add_render_item(@grid)
towns.start(:game)
