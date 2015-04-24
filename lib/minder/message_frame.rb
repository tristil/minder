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

    def prompt_message
      <<-TEXT
What are you working on?

Press (e) to open editor.
TEXT
    end

    def doing_message
      <<-TEXT
Currently working on:
<% object.tasks.each do |task| %>
-[ ] <%= task %>
<% end %>
TEXT
    end
  end
end
