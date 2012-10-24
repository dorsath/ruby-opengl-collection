require_relative 'font'
require_relative 'menu'
require_relative 'game'
require_relative 'texture_loader'

$font = Font.new

class SpaceInvaders
  include Gl
  include Glu
  include Glut

  attr_writer :show_menu

  def initialize
    glutInit

    glutInitDisplayMode GLUT_RGB | GLUT_DOUBLE | GLUT_ALPHA | GLUT_DEPTH
    glutInitWindowSize 640, 480
    glutInitWindowPosition 0, 0

    @window = glutCreateWindow "Space Invaders"
    @game = Game.new(self)
    @menu = Menu.new(self, @game)
    @show_menu = true
    @active_menu = :start
    @active_keys = {}
    # @interface = Interface.new

    glutDisplayFunc :draw_gl_scene
    glutReshapeFunc :reshape
    glutIdleFunc :idle
    glutSpecialFunc :keyboard
    glutSpecialUpFunc :keyboard_up

    reshape 640, 480
    init_gl
    $font.load
    @game.load
    glutMainLoop
  end

  def active_scene
    if @show_menu
      @menu
    else
      @game
    end
  end

  def draw_gl_scene

    glClear GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT
    glLoadIdentity

    active_scene.handle_keys(@active_keys)
    active_scene.draw

    glutSwapBuffers
  end

  def reshape width, height
    width  = width.to_f
    height = height.to_f
    height = 1.0 if height.zero?

    glViewport 0, 0, width, height

    glMatrixMode GL_PROJECTION
    glLoadIdentity

    # gluPerspective 45, width / height, 0.1, 200
    glOrtho(0, width, height, 0, 0, 1)

    glMatrixMode GL_MODELVIEW
    glLoadIdentity
  end

  def idle
    glutPostRedisplay
  end

  def init_gl
    glShadeModel GL_SMOOTH
    glClearColor 0, 0, 0, 0

    glClearDepth 1.0
    glDisable GL_DEPTH_TEST
    glBlendFunc GL_SRC_ALPHA, GL_ONE
    glHint GL_PERSPECTIVE_CORRECTION_HINT, GL_NICEST
    glHint GL_POINT_SMOOTH_HINT, GL_NICEST
  end

  def exit_game
    glutDestroyWindow @window
    exit 0
  end


  def keyboard key, x, y
    @active_keys[key] = true
    active_scene.keyboard(key)
  end

  def keyboard_up key, x, y
    @active_keys.delete(key)
  end

end

SpaceInvaders.new
