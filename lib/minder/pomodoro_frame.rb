require 'minder/frame'

module Minder
  class PomodoroFrame < Frame
    def template
      <<-TEXT
<%= subject.title %>

<%= subject.message %>
TEXT
    end

    def subject
      object.current_action
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
  end
end
