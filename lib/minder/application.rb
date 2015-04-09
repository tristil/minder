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
        char_code = get_keycode

        event = event_from_keycode(char_code)

        current_action = pomodoro_runner.current_action

        resolution = resolve_action(event, current_action)

        public_send(resolution, current_action)

        Curses.setpos(3, 0)
        Curses.addstr(' ' * 10)
        Curses.setpos(3, 0)
        Curses.refresh
      end
      Curses.close_screen
    end

    def update_screen(action)
      Curses.setpos(0,0)
      Curses.addstr(action.message)
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

    def end_interval(current_action)
      system("afplay #{ASSETS_LOCATION}/done.wav")
      current_action.complete!
      update_screen(current_action)
    end

    def start_interval(current_action)
      new_action = pomodoro_runner.advance_action
      new_action.start!
      system("afplay #{ASSETS_LOCATION}/start.wav")
      update_screen(new_action)
    end

    def running(current_action)
      update_screen(current_action)
    end

    def waiting(current_action)
      Curses.setpos(0,0)
      Curses.addstr('Press space to start next period')
    end

    def resolve_action(event, current_action)
      return :start_interval unless current_action

      if current_action.completed?
        if event == :continue
          :start_interval
        else
          :waiting
        end
      elsif current_action.elapsed?
        :end_interval
      else
        :running
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
