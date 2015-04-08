require 'minder/pomodoro'
require 'minder/pomodoro_break'

module Minder
  class PomodoroRunner
    attr_accessor :work_duration,
                  :short_break_duration,
                  :long_break_duration

    attr_reader :action_count,
                :current_action

    def initialize(**options)
      self.work_duration = options.fetch(:work_duration)
      self.short_break_duration = options.fetch(:short_break_duration)
      self.long_break_duration = options.fetch(:long_break_duration)
      @action_count = 0
    end

    def advance_action
      @action_count += 1

      if action_count.odd?
        @current_action = Pomodoro.new(minutes: work_duration)
      else
        @current_action = PomodoroBreak.new(minutes: break_duration)
      end
    end

    def break_duration
      if action_count % 8 == 0
        long_break_duration
      else
        short_break_duration
      end
    end
  end
end
