require 'opengl'
require_relative 'font'

$font = Font.new

class Base
  include Gl
  include Glu
  include Glut

  def initialize
    glutInit

    glutInitDisplayMode GLUT_RGB | GLUT_DOUBLE | GLUT_ALPHA | GLUT_DEPTH
    glutInitWindowSize 640, 480
    glutInitWindowPosition 0, 0

    @window = glutCreateWindow "Wat"
    @active_keys = []
    @last_time = time

    glutDisplayFunc :draw_gl_scene
    glutReshapeFunc :reshape
    glutIdleFunc :idle
    glutSpecialFunc :keyboard
    glutSpecialUpFunc :keyboard_up
    $font.load

    reshape 640, 480
    init_gl
    glutMainLoop
  end

  def draw_gl_scene

    glClear GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT
    glLoadIdentity

    #active_scene.handle_keys(@active_keys)
    #glTranslate((640 - 100) /2, 100, -480)
    #glRotate(45,-1,0,0)
    #glRotate(45,0,0,1)
    draw

    glutSwapBuffers
    @last_time = time
  end

  def time
    Time.now.to_f
  end

  def dt
    time - @last_time
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
    exit_game if key == 27
    @active_keys[key] = true
    #active_scene.keyboard(key)
  end

  def keyboard_up key, x, y
    @active_keys.delete(key)
  end

  def show_fps
    @fps ||= "fuck you"
    fps_elements << (dt)
    glColor(1,1,1)

    glLoadIdentity
    puts fps_elements.inject(:+)
    if fps_elements.inject(:+) > 0.1
      @fps = fps_elements.length.to_s
      @fps_elements = []
    end
    $font.print(@fps, 0, 0)
  end

  def fps_last_time
    @fps_last_time ||= time
  end

  def fps_elements
    @fps_elements ||= []
  end

end
