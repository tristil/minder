require 'minder/pomodoro/period'

module Minder
  class BreakPeriod < Period
    def initialize(minutes: DEFAULT_WORK_PERIOD)
      super
    end

    def title
      "Break period"
    end
  end
end
