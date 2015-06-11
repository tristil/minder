require 'minder/cli/frame'

module Minder
  class QuickAddFrame < Frame
    attr_accessor :input

    def initialize(*)
      super
      self.input = ''
    end

    def template
      <<-TEXT
Quick add task:
TEXT
    end

    def set_text
      self.lines[0] += ' ' + input
      super
    end

    def set_cursor_position
      window.setpos(1, template.strip.length + 2 + input.length)
    end

    def handle_char_keypress(key)
      self.input += key
      refresh
    end

    def handle_non_char_keypress(key)
      case key
      when *Curses::Key::BACKSPACE, 127
        self.input.chop!
        refresh
      when 10
        changed
        notify_observers(:add_task, { task: input })
        self.input = ''
        refresh
      end
    end
  end
end
