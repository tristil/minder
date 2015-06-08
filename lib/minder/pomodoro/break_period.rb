require 'minder/pomodoro/period'

module Minder
  class BreakPeriod < Period
    attribute :duration_in_seconds, Integer, default: DEFAULT_BREAK_PERIOD * 60

    def title
      "Break period"
    end

    def type
      'break'
    end
  end
end
