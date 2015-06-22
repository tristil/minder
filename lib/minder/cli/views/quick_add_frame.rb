require 'minder/cli/frame'

module Minder
  class QuickAddFrame < Frame
    attr_accessor :input

    def initialize(*)
      super
      self.input = ''
    end

    def setup
      interface 'quick_add' do
        border do
          'C'
        end
        geometry do
          height 3
          y Vedeu.height - 3
        end
        cursor!
        group 'main'
      end
    end

    def view_name
      'quick_add'
    end

    def template
      <<-TEXT
Quick add task:
TEXT
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
