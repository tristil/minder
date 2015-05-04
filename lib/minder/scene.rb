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
      next_frame = frames[current_index + 1]
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

      current_height = 0
      frames.each_with_index do |frame, index|
        frame.listen if frame.focused?

        if index == 0
          current_height += frame.height
          next
        end

        unless frame.hidden?
          frame.move(current_height, 0)
          current_height += frame.height
        end
      end
    end

    def redraw
      refresh
      resize_frames
      refresh
      Curses.curs_set(1)
      focused_frame.set_cursor_position
      focused_frame.window.refresh
    end

    def clear
      Curses.clear
    end

    def close
      Curses.close_screen
    end
  end
end
