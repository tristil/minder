require 'minder/frame'

module Minder
  class PomodoroFrame < Frame
    def template
      <<-TEXT
<%= @object.title %>

<%= @object.message %>
TEXT
    end
  end
end
