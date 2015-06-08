require 'observer'

module Minder
  class TaskEditor
    include Observable

    attr_reader :cursor_position

    def initialize(task, parent)
      @original_text = task.description.dup
      @cursor_position = 0
      @task = task
      @parent = parent
    end

    def text
      @task.description
    end

    def handle_keypress(key)
      return unless key

      if key.is_a?(Fixnum)
          handle_non_char_keypress(key)
      else
        handle_char_keypress(key)
      end
    end

    def handle_non_char_keypress(key)
      return unless key

      data = {}

      event =
        case key
        when Curses::Key::LEFT
          @cursor_position -= 1 unless cursor_position == 0
          :redraw
        when Curses::Key::RIGHT
          @cursor_position += 1 unless cursor_position > text.length - 1
          :redraw
        when Curses::Key::BACKSPACE
          return if @cursor_position == 0
          @task.description.slice!(@cursor_position - 1)
          @cursor_position -= 1 unless cursor_position == 0
          :redraw
        when 27, 9
          @task.description = @original_text
          :stop_editing
        when 10
          data = { description: @task.description }
          :update_task
        end

      changed
      notify_observers(event, data)
    end

    def handle_char_keypress(key)
      @task.description.insert(@cursor_position, key)
      @cursor_position += 1

      changed
      notify_observers(:redraw)
    end
  end
end
