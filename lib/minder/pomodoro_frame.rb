require 'minder/frame'

module Minder
  class PomodoroFrame < Frame
    def template
      text = <<-TEXT
<%= period.title %>
TEXT

      if period.message
        text += <<-TEXT

<%= period.message %>
TEXT
      end

      if task_manager.started_task
        text += <<-TEXT

Working on: #{task_manager.started_task}
TEXT
      end

      text
    end

    def period
      pomodoro_runner.current_action
    end

    def handle_char_keypress(key)
      event = case key
      when ' ' then :continue
      when 'e' then :editor
      end

      changed
      notify_observers(event)
    end

    def handle_non_char_keypress(key)
      event = case key
      when 3 then :exit
      end

      changed
      notify_observers(event)
    end

    def set_cursor_position
      window.setpos(1, lines[0].strip.length + 2)
    end
  end
end
