module Minder
  class Scene
    attr_accessor :action,
                  :tasks,
                  :window

    def initialize(action: nil, tasks: nil)
      self.action = action
      self.tasks = tasks
    end

    def setup
      Curses.noecho
      Curses.init_screen
      Curses.timeout = 0

      self.window = Curses::Window.new(5, 40, 0, 0)
      window.box(?|, ?-)
    end

    def update
      window.setpos(1,1)
      print_line(action.title)
      window.setpos(3,1)
      print_line(action.message)
      window.refresh
    end

    def print_line(text)
      remainder = 38 - text.length
      window.addstr(text + ' ' * remainder)
    end

    def close
      Curses.close_screen
    end
  end
end
