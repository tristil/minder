require 'minder/cli/frame'

module Minder
  class PomodoroFrame < Frame
    def template
      text = <<-TEXT
<%= period.title %>  #{pomodoros}
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
      pomodoro_runner.current_period
    end

    def handle_char_keypress(key)
      event = case key
      when ' ' then :continue
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

    def pomodoros
      pomodoro_runner.pomodoros_today.map do |pomodoro|
        "#{pomodoro_runner.emoji} "
      end.join
    end
  end
end
