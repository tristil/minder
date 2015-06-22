require 'minder/cli/frame'

module Minder
  class SearchFrame < Frame
    attr_reader :search_string

    def initialize(*)
      super
      @search_string = ''
    end

    def setup
      interface 'search' do
        border do
          'C'
        end
        geometry do
          height 5
        end
        cursor!
        hide!
        group 'main'
      end
    end

    def desired_height
      3
    end

    def view_name
      'search'
    end

    def template
      <<-TEXT
/#{search_string}
TEXT
    end

    def set_cursor_position
      window.setpos(1, search_string.length + 2)
    end

    def handle_char_keypress(key)
      return unless key

      @search_string += key
      refresh
    end

    def handle_non_char_keypress(key)
      case key
      when 27
        changed
        notify_observers(:escape_search)
      when *Curses::Key::BACKSPACE, 127
        @search_string.chop!
        refresh
      when 10
        changed
        notify_observers(:submit_search, { text: search_string })
        refresh
      end
    end

    def begin_search
      @search_string = ''
    end
  end
end

