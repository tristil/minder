require 'ostruct'
require 'minder/pomodoro_frame'
require 'minder/message_frame'
require 'minder/quick_add_frame'

module Minder
  class Scene
    attr_accessor :frames

    def initialize
      self.frames = []
    end

    def setup
      Curses.noecho
      Curses.init_screen
      Curses.timeout = 0
      clear
      Curses.refresh
    end

    def focused_frame
      frames.find(&:focused?)
    end

    def switch_focus
      current_index = frames.find_index(focused_frame)
      focused_frame.unfocus
      next_frame = frames[current_index + 1..-1].find { |frame| !frame.hidden? }
      if next_frame
        next_frame.focus
      else
        frames[0].focus
      end
    end

    def refresh
      frames.map(&:refresh)
    end

    def resize_frames
      frames.map(&:resize)

      available_height = Curses.lines - frames.last.height

      frames.first.move(0, 0)
      next_height = frames.first.height
      second_frame = frames[1]

      unless second_frame.hidden?
        proposed_height = available_height - frames.first.height
        if proposed_height < second_frame.desired_height
          second_frame.height = proposed_height
        else
          second_frame.height = second_frame.desired_height
        end
        second_frame.move(next_height, 0)
        next_height += second_frame.height
      end

      if next_height <= available_height
        frames.last.move(next_height, 0)
      else
        frames.last.move(available_height, 0)
      end
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
