require 'minder/frame'

module Minder
  class MessageFrame < Frame
    def template
      <<-TEXT
<%= @object.message %>
TEXT
    end
  end
end
