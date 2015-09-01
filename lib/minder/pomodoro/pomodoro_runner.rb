require 'observer'

require 'minder/pomodoro/work_period'
require 'minder/pomodoro/break_period'
require 'minder/pomodoro/idle_period'

module Minder
  class PomodoroRunner
    include Observable

    attr_accessor :work_duration,
                  :short_break_duration,
                  :long_break_duration,
                  :database,
                  :emoji

    attr_reader :period_count,
                :current_period

    def initialize(**options)
      self.work_duration = options.fetch(:work_duration)
      self.short_break_duration = options.fetch(:short_break_duration)
      self.long_break_duration = options.fetch(:long_break_duration)
      self.database = options.fetch(:database)
      self.emoji = options.fetch(:emoji)
      @period_count = 0
      current_period = IdlePeriod.new
      current_period.start!
      database.add_period(current_period)
      @current_period = database.last_period
    end

    def tick
      return if !current_period.elapsed? || current_period.completed?

      old_period = current_period
      complete_period(old_period)
      @current_period = IdlePeriod.new

      changed
      if old_period.is_a?(WorkPeriod)
        notify_observers(:completed_work)
      elsif old_period.is_a?(BreakPeriod)
        notify_observers(:completed_break)
      end
    end

    def continue
      return unless current_period.elapsed?

      complete_period(current_period)

      advance_period
      current_period.start!
      database.add_period(current_period)
      @current_period = database.last_period
    end

    def complete_period(period)
      period.complete!
      database.complete_period(period)
      @pomodoros_today = nil
    end

    def advance_period
      @period_count += 1
      changed

      if period_count.odd?
        notify_observers(:started_work)
        @current_period = WorkPeriod.new(duration_in_minutes: work_duration)
      else
        notify_observers(:started_break)
        @current_period = BreakPeriod.new(duration_in_minutes: break_duration)
      end
    end

    def break_duration
      if period_count % 8 == 0
        long_break_duration
      else
        short_break_duration
      end
    end

    def pomodoros_today
      @pomodoros_today ||= database.pomodoros_today
    end

    def periods
      database.periods
    end
  end
end
