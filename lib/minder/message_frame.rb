require 'minder/frame'

module Minder
  class MessageFrame < Frame
    def template
      if object.tasks?
        doing_message
      else
        prompt_message
      end
    end

    def build_window
      Curses::Pad.new(min_height, width)
    end

    def prompt_message
      <<-TEXT
What are you working on?

Press (e) to open editor.
TEXT
    end

    def doing_message
      text = <<-TEXT
Currently working on:

TEXT
      object.tasks.each do |task|
        text += "-[ ] #{task}\n"
      end
      text
    end

    def set_cursor_position
      window.setpos(3 + object.selected_task_index, 3)
    end

    def handle_char_keypress(key)
      event = case key
      when 'j' then :select_next_task
      when 'k' then :select_previous_task
      when 'd' then :delete_task
      end

      changed
      notify_observers(event)
    end
  end
end
