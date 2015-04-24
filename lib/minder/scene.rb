require 'ostruct'
require 'minder/pomodoro_frame'
require 'minder/message_frame'

module Minder
  class Scene
    attr_accessor :action,
                  :tasks,
                  :window,
                  :message_window

    def initialize(action: nil, tasks: nil)
      self.action = action
      self.tasks = tasks
    end

    def setup
      Curses.noecho
      Curses.init_screen
      Curses.timeout = 0

      self.window = PomodoroFrame.new(
        height: 5,
        width: 40,
        top: 0,
        left: 0)

      self.message_window = MessageFrame.new(
        height: 5,
        width: 40,
        top: 7,
        left: 0)
    end

    def update
      window.object = action
      window.refresh

      message_window.object = OpenStruct.new(
        message: 'What are you working on?'
      )
      message_window.refresh
    end

    def print_line(text)
      remainder = 38 - text.length
      window.addstr(text + ' ' * remainder)
    end

    def close
      Curses.close_screen
    end
  end
end
