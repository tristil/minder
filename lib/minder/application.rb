require 'minder/config'
require 'minder/pomodoro_runner'

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
      system('clear')
      current_action = nil

      current_action = pomodoro_runner.advance_action
      current_action.start!

      loop do
        char_code = get_keypress
        exit if char_code == 3
        current_action = pomodoro_runner.current_action

        if current_action.completed?
          if char_code == 32
            new_action = pomodoro_runner.advance_action
            new_action.start!
            system("afplay #{ASSETS_LOCATION}/start.wav")
            print "                                \r"
          else
            print "Press space to start next period\r"
          end
        elsif current_action.elapsed?
          system("afplay #{ASSETS_LOCATION}/done.wav")
          current_action.complete!
        else
          update_screen(current_action)
        end
      end
    end

    def update_screen(action)
      print "#{action.message}\r"
      STDOUT.flush
    end

    def pomodoro_runner
      @runner ||= PomodoroRunner.new(
        work_duration: config.work_duration,
        short_break_duration: config.short_break_duration,
        long_break_duration: config.long_break_duration)
    end

    def get_keypress
      system("stty raw -echo") #=> Raw mode, no echo
      char_code = (STDIN.read_nonblock(1).ord rescue nil)
      system("stty -raw echo") #=> Reset terminal mode
      char_code
    end
  end
end
