require 'minder/frame'

module Minder
  class FilterFrame < Frame
    attr_reader :filter_string

    def initialize(*)
      super
      @filter_string = ''
    end

    def desired_height
      3
    end

    def template
      <<-TEXT
Filter: #{filter_string}
TEXT
    end

    def set_cursor_position
      window.setpos(1, filter_string.length + 9)
    end

    def handle_char_keypress(key)
      return unless key

      @filter_string += key
      refresh
      changed
      notify_observers(:update_filter, { text: filter_string })
    end

    def handle_non_char_keypress(key)
      if key == 10
        changed
        notify_observers(:submit_filter, { text: filter_string })
      end

      @filter_string.chop! if key == 127

      refresh
      changed
      notify_observers(:update_filter, { text: filter_string })
    end
  end
end

