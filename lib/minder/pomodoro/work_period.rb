require 'minder/pomodoro/period'

module Minder
  class WorkPeriod < Period
    attribute :duration_in_seconds, Integer, default: DEFAULT_WORK_PERIOD * 60

    def title
      "Work period"
    end

    def type
      'work'
    end
  end
end
