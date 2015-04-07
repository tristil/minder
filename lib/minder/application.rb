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

      loop do
        puts 'Press space to start next period'
        wait_for_char(' ')

        next_pomodoro_action
      end
    end

    def next_pomodoro_action
      action = pomodoro_runner.next_action
      action.run

      puts ''
      puts ''
    end

    def pomodoro_runner
      @runner ||= PomodoroRunner.new(
        work_duration: config.work_duration,
        short_break_duration: config.short_break_duration,
        long_break_duration: config.long_break_duration)
    end

    def wait_for_char(expected_char)
      loop do
        system("stty raw -echo") #=> Raw mode, no echo
        char = STDIN.getc
        system("stty -raw echo") #=> Reset terminal mode
        break if char == expected_char
      end
    end
  end
end
