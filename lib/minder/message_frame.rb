require 'minder/frame'

module Minder
  class MessageFrame < Frame
    def template
      if task_manager.tasks?
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
Tasks        (s) start (x) to delete (d) to mark as done

TEXT
      task_manager.tasks.each do |task|
        if task.started?
          text += "-[*] #{task}\n"
        else
          text += "-[ ] #{task}\n"
        end
      end
      text
    end

    def set_cursor_position
      window.setpos(3 + task_manager.selected_task_index, 3)
    end

    def handle_char_keypress(key)
      event = case key
      when 'j' then :select_next_task
      when 'k' then :select_previous_task
      when 'd' then :complete_task
      when 'x' then :delete_task
      when 's' then :start_task
      when 's' then :unstart_task
      end

      changed
      notify_observers(event)
    end
  end
end
