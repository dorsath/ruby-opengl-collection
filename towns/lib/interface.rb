# require_relative 'interface/action'

class Interface
  def initialize
    @buttons = []
    @button_background = Sprite.find("ui.png", 0, 320, 65, 64)
  end

  def draw
    @buttons.each do |button|
      Walker::Base.driver.draw.button(button[:options].merge(background: @button_background))
    end
  end

  def add_button(action, options)
    @buttons << {action: action, options: options}
  end


  def check_for_interface(x, y)
    @buttons.each do |button|
      button[:action].call if within_hitbox?(button[:options][:hitbox], x, y)
    end
  end

  def mouse_handler(*args)
    check_for_interface(*args[2..3])
  end


  def within_hitbox?(hitbox, x, y)
    hitbox.check(x, y)
  end
end
