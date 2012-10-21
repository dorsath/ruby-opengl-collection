class Menu
  attr_reader :game

  def initialize(game)
    @active_menu = menu.first
    @game = game
  end

  def keyboard(key)
    case key
    when ?\e
      game.show_menu = true
    when ?w
      up
    when ?s
      down
    when ?\r
      select
    end
  end

  def up
    @active_menu = menu[(menu.index(@active_menu) - 1)]
  end

  def down
    index = menu.index(@active_menu)
    if (index + 1) >= menu.length
      @active_menu = menu.first
    else
      @active_menu = menu[index + 1]
    end
  end

  def select
    case @active_menu
    when :start
      game.show_menu = false
    when :exit
      game.exit_game
    end
  end

  def menu
    [:start, :exit]
  end

  def draw
    $font.print("Space Invaders",300,50, :center)

    i = 0
    menu.each do |title|
      glLoadIdentity
      $font.print(title.to_s, 300, 90 + i * 20, :center)
      i += 1

      if @active_menu == title
        glTranslate(300 - ((title.to_s.length/2) * 16), 89 + i * 20,0)
        glScale(title.to_s.length * 16,1,1)
        glBegin(GL_QUADS) do
          glColor(1,1,1)
          glVertex(0,1,0)
          glVertex(1,1,0)
          glVertex(1,0,0)
          glVertex(0,0,0)
        end
      end
    end
  end
end
