require 'minder/period'

module Minder
  class PomodoroPeriod < Period
    def initialize(minutes: DEFAULT_WORK_PERIOD)
      super
    end

    def title
      "Work period"
    end
  end
end
