require 'minder/pomodoro'
require 'minder/pomodoro_break'

module Minder
  class PomodoroRunner
    attr_accessor :work_duration,
                  :short_break_duration,
                  :long_break_duration
    def initialize(**options)
      self.work_duration = options.fetch(:work_duration)
      self.short_break_duration = options.fetch(:short_break_duration)
      self.long_break_duration = options.fetch(:long_break_duration)
    end

    def run(config: nil)
      system('clear')

      3.times do
        pomodoro = Pomodoro.new(minutes: work_duration)
        pomodoro.run

        lines

        pomodoro_break = PomodoroBreak.new(minutes: short_break_duration)
        pomodoro_break.run

        lines
      end

      pomodoro = Pomodoro.new(minutes: work_duration)
      pomodoro.run

      lines

      pomodoro_break = PomodoroBreak.new(minutes: long_break_duration)
      pomodoro_break.run
    end

    def lines
      puts ""
      puts ""
    end
  end
end
