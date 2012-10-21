require 'opengl'
require_relative 'sprites'
require_relative 'world'
require_relative 'character'
require_relative 'font'


$sprites = Sprites.new

class Pokemon
  include Gl
  include Glu
  include Glut

  def initialize
    glutInit

    glutInitDisplayMode GLUT_RGB | GLUT_DOUBLE | GLUT_ALPHA | GLUT_DEPTH
    glutInitWindowSize 640, 480
    glutInitWindowPosition 0, 0

    @window = glutCreateWindow "Pokemon"
    @window_offset = [-15,10]
    @character = Character.new("Ash")

    @world = World.new
    @font = Font.new

    glutDisplayFunc :draw_gl_scene
    glutReshapeFunc :reshape
    glutIdleFunc :idle
    glutKeyboardFunc :keyboard

    reshape 640, 480
    init_gl
    @font.load
    glutMainLoop
  end

  def draw_gl_scene
    glClear GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT
    glLoadIdentity
    @world.draw()
    glLoadIdentity
    @font.print("Cool so now i can write stuff in opengl :D",0, 50)
    glLoadIdentity
    @character.draw()
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

  def keyboard key, x, y
    case key
    when ?\e
      glutDestroyWindow @window
      exit 0
    when "w"
      @character.move_up
    when 's'
      @character.move_down
    when 'a'
      @character.move_left
    when 'd'
      @character.move_right
    when "F"
      @fullscreen = !@fullscreen

      if @fullscreen then
        glutFullScreen
      else
        glutPositionWindow 0, 0
      end
    end
  end

end

Pokemon.new
