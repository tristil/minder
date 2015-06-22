require 'observer'
require 'erb'

module Minder
  class Frame
    include Vedeu
    include Observable

    attr_accessor :window,
                  :min_height,
                  :height,
                  :left,
                  :top,
                  :pomodoro_runner,
                  :task_manager,
                  :lines

    def initialize(**options)
      height = options.fetch(:height, 3)
      top = options.fetch(:top, 0)
      left = options.fetch(:left, 0)
      task_manager = options.fetch(:task_manager)
      pomodoro_runner = options.fetch(:pomodoro_runner)

      @focused = false
      @hidden = false
      @has_cursor = false
      self.pomodoro_runner = pomodoro_runner
      self.task_manager = task_manager
      self.min_height = height

      self.height = height
      self.top = top
      self.left = left

      self.lines = []

      Vedeu.bind(:_focus_next_) do
        #require 'pry'
        #binding.pry
      end
    end

    def show
      parse_template
      lines_from_template = @lines
      views do
        view view_name do
          lines do
            lines_from_template.each do |l|
              line l
            end
          end
        end
      end
    end

    def focus
      Vedeu.focus_by_name(view_name)
      @focused = true
      @has_cursor = true
    end

    def unfocus
      @focused = false
      @has_cursor = false
    end

    def focused?
      @focused
    end

    def hidden?
      @hidden
    end

    def hide
      Vedeu.trigger(:_hide_interface_, view_name)
      @hidden = true
    end

    def unhide
      Vedeu.trigger(:_show_interface_, view_name)
      @hidden = false
    end

    def template
      raise NotImplementedError
    end

    def move(top, left)
      window.move(top, left)
    end

    def has_cursor?
      @has_cursor
    end

    def refresh
      Vedeu.update.call
    end

    def parse_template
      b = binding
      self.lines = ERB.new(template).result(b).split("\n")
    end

    def set_cursor_position
      window.setpos(1, 0)
    end
  end
end
