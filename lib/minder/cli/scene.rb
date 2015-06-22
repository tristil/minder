module Minder
  class Scene
    attr_accessor :frames

    def initialize
      self.frames = []
    end

    def setup
      frames.each(&:setup)
      frames.each(&:show)

      Vedeu.focus_by_name('pomodoro')
      Vedeu::Launcher.new().execute!
    end

    def focused_frame
      frames.find(&:focused?)
    end

    def switch_focus
      Vedeu.focus_next
    end

    def focus_frame(frame)
      focused_frame.unfocus
      frame.focus
    end

    def refresh
      frames.map(&:refresh)
    end

    def resize_frames
      frames.map(&:resize)
      first_frame = frames.first

      first_frame.move(0, 0)
      next_height = first_frame.height

      other_frames = (frames.reject(&:hidden?) - [main_frame]).compact
      if main_frame

        other_height = other_frames.reduce(0) do |num, frame|
          num += frame.height
          num
        end

        available_height = Curses.lines - other_height

        if available_height > main_frame.desired_height
          main_frame.height = main_frame.desired_height
        else
          main_frame.height = available_height
        end
        main_frame.move(next_height, 0)

        next_height += main_frame.height
      end

      (other_frames - [first_frame]).each do |frame|
        frame.move(next_height, 0)
        next_height += frame.height
      end
    end

    def main_frame
      return if tasks_frame.hidden? && help_frame.hidden?

      if tasks_frame.hidden?
        help_frame
      else
        tasks_frame
      end
    end

    def tasks_frame
      @tasks_frame ||= frames.find { |frame| frame.is_a?(TasksFrame) }
    end

    def help_frame
      @help_frame ||= frames.find { |frame| frame.is_a?(HelpFrame) }
    end

    def redraw
      refresh
      resize_frames
      refresh
      Curses.curs_set(1)
      focused_frame.set_cursor_position
      focused_frame.window_refresh
    end

    def clear
      Curses.clear
    end

    def close
      Curses.close_screen
    end
  end
end
