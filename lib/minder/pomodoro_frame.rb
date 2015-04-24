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
  end
end
