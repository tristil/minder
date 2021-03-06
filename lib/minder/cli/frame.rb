require 'observer'
require 'erb'

module Minder
  class Frame
    include Observable

    attr_accessor :window,
                  :min_height,
                  :height,
                  :width,
                  :left,
                  :top,
                  :pomodoro_runner,
                  :task_manager,
                  :lines

    def initialize(**options)
      height = options.fetch(:height, 3)
      width = options.fetch(:width, 40)
      top = options.fetch(:top, 0)
      left = options.fetch(:left, 0)
      task_manager = options.fetch(:task_manager)
      pomodoro_runner = options.fetch(:pomodoro_runner)

      @focused = false
      @hidden = false
      @has_cursor = false
      self.pomodoro_runner = pomodoro_runner
      self.task_manager = task_manager
      self.min_height = height

      self.height = height
      self.width = width
      self.top = top
      self.left = left

      self.window = build_window
      window.keypad(true)
      self.lines = []
    end

    def build_window
      Curses::Window.new(min_height, width, top, left)
    end

    def focus
      @focused = true
      @has_cursor = true
    end

    def unfocus
      @focused = false
      @has_cursor = false
    end

    def focused?
      @focused
    end

    def hidden?
      @hidden
    end

    def hide
      erase
      @hidden = true
    end

    def unhide
      @hidden = false
    end

    def template
      raise NotImplementedError
    end

    def move(top, left)
      window.move(top, left)
    end

    def has_cursor?
      @has_cursor
    end

    def listen
      window.timeout = 0
      handle_keypress(window.getch)
    end

    def refresh
      return if @hidden
      parse_template
      set_text
      window_refresh
    end

    def window_refresh
      window.refresh
    end

    def parse_template
      b = binding
      self.lines = ERB.new(template).result(b).split("\n")
    end

    def resize
      erase

      self.width = Curses.cols
      if lines.length >= min_height - 2
        self.height = lines.length + 2
      else
        self.height = min_height
      end

      window.resize(height, width)
      window_refresh
    end

    def set_text
      window.box(?|, ?-)
      height.times do |index|
        next if index >= height - 2
        window.setpos(index + 1, 1)
        line = lines[index]
        if line
          print_line(line)
        else
          print_line('')
        end
      end
    end

    def erase
      height.times do |index|
        window.setpos(index, 0)
        window.addstr(' ' * width )
      end
      window_refresh
    end

    def set_cursor_position
      window.setpos(1, 0)
    end

    def print_line(text)
      text = text[0,width - 2]
      remainder = width - 2 - text.length
      window.addstr(text + ' ' * remainder)
    end

    def handle_keypress(key)
      return unless key

      if key.is_a?(Fixnum)
        if key == 9 # tab
          changed
          notify_observers(:switch_focus)
        else
          handle_non_char_keypress(key)
        end
      else
        handle_char_keypress(key)
      end
    end

    def handle_non_char_keypress(key)
    end

    def handle_char_keypress(key)
    end
  end
end
