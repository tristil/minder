require 'minder/pomodoro_period'
require 'minder/break_period'
require 'minder/idle_period'

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
      @current_action = IdlePeriod.new
    end

    def tick
      if current_action.elapsed? && !current_action.completed?
        current_action.complete!
        @current_action = IdlePeriod.new
      end
    end

    def continue
      advance_action
      current_action.start!
    end

    def advance_action
      @action_count += 1

      if action_count.odd?
        @current_action = PomodoroPeriod.new(minutes: work_duration)
      else
        @current_action = BreakPeriod.new(minutes: break_duration)
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
