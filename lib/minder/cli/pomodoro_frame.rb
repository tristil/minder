require 'minder/cli/frame'
require 'emoji'

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
      index = Emoji::Index.new
      pomodoro_runner.pomodoros_today.map do |pomodoro|
        "\xF0\x9F\x8D\x85 "
      end.join
    end
  end
end
