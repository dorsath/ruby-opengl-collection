require_relative 'base'

class Ottd < Base

  def handle_keyboard(keys)
  end

  def handle_single_keyboard(key)
    exit_game if key == 27
  end
end

Ottd.new
