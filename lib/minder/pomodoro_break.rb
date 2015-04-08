require 'minder/interval'

module Minder
  class PomodoroBreak < Interval
    def initialize(minutes: DEFAULT_WORK_PERIOD)
      super
    end

    def preamble
      "Break period"
    end
  end
end
