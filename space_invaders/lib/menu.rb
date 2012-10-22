class Menu
  attr_reader :base, :game
  attr_accessor :active_menu

  def initialize(base, game)
    @base = base
    @game = game
    @active_menu = menu.first
  end

  def keyboard(key)
    case key
    when 101
      up
    when 103
      down
    when 13
      select
    end
  end

  def handle_keys(keys)
  end

  def up
    @active_menu = menu[(menu.index(active_menu) - 1)]
  end

  def active_menu
    @active_menu ||= menu.first
  end

  def down
    index = menu.index(active_menu)
    if (index + 1) >= menu.length
      @active_menu = menu.first
    else
      @active_menu = menu[index + 1]
    end
  end

  def select
    case @active_menu
    when :start, :restart
      base.show_menu = false
      game.start
    when :continue
      base.show_menu = false
      game.continue
    when :exit
      base.exit_game
    end
    @active_menu = nil
  end

  def menu
    if game.started?
      [:continue, :restart, :exit]
    else
      [:start, :exit]
    end
  end

  def draw
    $font.print("Space Invaders",300,50, :center)

    i = 0
    menu.each do |title|
      glLoadIdentity
      $font.print(title.to_s, 300, 90 + i * 20, :center)
      i += 1

      if active_menu == title
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
