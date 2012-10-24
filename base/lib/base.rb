require 'opengl'

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

    glutDisplayFunc :draw_gl_scene
    glutReshapeFunc :reshape
    glutIdleFunc :idle
    glutSpecialFunc :keyboard
    glutSpecialUpFunc :keyboard_up

    reshape 640, 480
    init_gl
    glutMainLoop
  end

  def draw_gl_scene

    glClear GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT
    glLoadIdentity

    #active_scene.handle_keys(@active_keys)

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
