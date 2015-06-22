module Cli2
  class FilterView < Vedeu::ApplicationView
    attr_reader :filter_string

    def initialize(*)
      super
      @filter_string = ''
    end

    def render
      Vedeu.renders do
        template_for('filter', template('filter'), context, options)
      end
    end

    private

    def context
      OpenStruct.new(filter_string: filter_string)

    end

    def options
      {}
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

      @filter_string.chop! if [Curses::Key::BACKSPACE, 127].include?(key)

      refresh
      changed
      notify_observers(:update_filter, { text: filter_string })
    end
  end
end
