require 'minder/config'
require 'minder/pomodoro_runner'

require 'curses'

module Minder
  class Application
    attr_accessor :config

    def initialize(config: Minder::Config.new(CONFIG_LOCATION))
      self.config = config
      config.load
    end

    def config_location
      config.location
    end

    def run
      Curses.noecho
      Curses.init_screen
      Curses.timeout = 0

      loop do
        pomodoro_runner.tick

        char_code = get_keycode
        event = event_from_keycode(char_code)

        resolution = handle_event(event)

        current_action = pomodoro_runner.current_action
        update_screen(current_action)

        Curses.setpos(5, 0)
        Curses.addstr(' ' * 10)
        Curses.setpos(5, 0)
        Curses.refresh
      end
      Curses.close_screen
    end

    def update_screen(action)
      Curses.setpos(0,0)
      Curses.addstr(action.title + (' ' * 30))
      Curses.setpos(3,0)
      Curses.addstr(action.message + (' ' * 30))
    end

    def pomodoro_runner
      @runner ||= PomodoroRunner.new(
        work_duration: config.work_duration,
        short_break_duration: config.short_break_duration,
        long_break_duration: config.long_break_duration)
    end

    def get_keycode
      char = Curses.getch
      char && char.ord
    end

    def handle_event(event)
      if event == :continue
        pomodoro_runner.continue
      end
    end

    def event_from_keycode(keycode)
      case keycode
      when 3 then :exit
      when 32 then :continue
      end
    end
  end
end
