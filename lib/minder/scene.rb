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
    end

    def update
      current_height = 0
      frames.each_with_index do |frame, index|
        if index == 0
          frame.refresh
          next
        end

        current_height += frames[index - 1].height
        frame.move(current_height, 0)
        frame.refresh
      end
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

    def clear
      Curses.clear
    end

    def close
      Curses.close_screen
    end
  end
end
