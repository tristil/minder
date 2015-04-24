require 'ostruct'
require 'minder/pomodoro_frame'
require 'minder/message_frame'

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
      Curses.curs_set(0)
      clear
    end

    def update
      frames.map(&:refresh)
      Curses.refresh
    end

    def clear
      Curses.clear
    end

    def close
      Curses.close_screen
    end
  end
end
