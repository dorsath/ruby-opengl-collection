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
    @active_keys = {}
    @last_time = time

    glutDisplayFunc :draw_gl_scene
    glutReshapeFunc :reshape
    glutIdleFunc :idle
    glutSpecialFunc :keyboard
    glutSpecialUpFunc :keyboard_up
    glutMouseFunc :mouse
    glutPassiveMotionFunc :mouse_movement
    $font.load

    reshape 640, 480
    init_gl
  end

  def start
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
    glHint GL_PERSPECTIVE_CORRECTION_HINT, GL_NICEST
    glHint GL_POINT_SMOOTH_HINT, GL_NICEST
  end

  def exit_game
    glutDestroyWindow @window
    exit 0
  end


  def keyboard key, x, y
    exit_game if key == 113
    @active_keys[key] = true
    handle_single_keys(key, x, y)
  end

  def keyboard_up key, x, y
    @active_keys.delete(key)
  end

  def mouse *args
    if args[1] == 1
      mouse_handler(*args)
    end
  end

  def mouse_movement(*args)
    mouse_movement_handler(*args)
  end

  def show_fps
    @frames_count  ||= 0
    @frames_count += 1

    @fps ||= "loading..."

    if (time - fps_last_time) > 1
      @fps = @frames_count.to_s
      @frames_count = 0
      @fps_last_time = time
    end

    $font.print(@fps, 0, 0)
  end

  def fps_last_time
    @fps_last_time ||= 0
  end
end
