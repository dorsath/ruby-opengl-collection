module Opengl
  class Base
    include Gl
    include Glu
    include Glut

    attr_writer :resolution
    attr_accessor :draw_hook

    def initialize(options = {})
      print "Initializing opengl\n"
      @resolution = options[:resolution] || [640,480]
      @active_keys= []
      @draw_items = []
      @items = []
      glutInit

      glutInitDisplayMode GLUT_RGB | GLUT_DOUBLE | GLUT_ALPHA | GLUT_DEPTH
      glutInitWindowSize *@resolution
      glutInitWindowPosition 0, 0

      @window = glutCreateWindow "Wat"

      glutDisplayFunc :draw_gl_scene
      glutReshapeFunc :reshape
      glutIdleFunc :idle
      # glutSpecialFunc :keyboard
      glutSpecialUpFunc :keyboard_up
      glutMouseFunc :mouse

      reshape *@resolution
      init_gl
    end

    def textures
      Textures
    end

    def draw
      Draw
    end

    def start
      glutMainLoop
    end

    def draw_gl_scene
      glClear GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT
      glLoadIdentity
      draw_items
      glutSwapBuffers
    end

    def draw_items
      @draw_hook.draw
      @items.each do |item|
        glPushMatrix
        item.draw
        glPopMatrix
      end
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

    def keyboard_up(key, x, y)
      exit_game if key == 27
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

    def mouse *args
      if args[1] == 1
        draw_hook.mouse_handler(*args)
      end
    end

    def exit_game
      glutDestroyWindow @window
      exit 0
    end

    def add_render_item(item)
      @items << item
    end
  end
end
