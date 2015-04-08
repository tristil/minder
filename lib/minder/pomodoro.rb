require 'minder/interval'

module Minder
  class Pomodoro < Interval
    attr_accessor :minutes

    def initialize(minutes: DEFAULT_WORK_PERIOD)
      super
    end

    def preamble
      "Work period"
    end
  end
end
