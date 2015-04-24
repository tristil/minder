require 'observer'

require 'minder/pomodoro_period'
require 'minder/break_period'
require 'minder/idle_period'

module Minder
  class PomodoroRunner
    include Observable

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
      return if !current_action.elapsed? || current_action.completed?

      changed
      if current_action.is_a?(PomodoroPeriod)
        notify_observers(:completed_work)
      elsif current_action.is_a?(PomodoroBreak)
        notify_observers(:completed_break)
      end

      current_action.complete!
      @current_action = IdlePeriod.new
    end

    def continue
      return unless current_action.elapsed?

      advance_action
      current_action.start!
    end

    def advance_action
      @action_count += 1
      changed

      if action_count.odd?
        notify_observers(:started_work)
        @current_action = PomodoroPeriod.new(minutes: work_duration)
      else
        notify_observers(:started_break)
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
