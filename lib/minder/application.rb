require 'minder/config'
require 'minder/pomodoro_runner'
require 'forwardable'

module Minder
  class Application
    extend Forwardable

    attr_accessor :config

    def initialize(config: Minder::Config.new(CONFIG_LOCATION))
      self.config = config
      config.load
    end

    def config_location
      config.location
    end

    def run
      pomodoro_runner = PomodoroRunner.new(
        work_duration: config.work_duration,
        short_break_duration: config.short_break_duration,
        long_break_duration: config.long_break_duration)
      pomodoro_runner.run
    end
  end
end
