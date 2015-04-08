require 'minder/timer'

module Minder
  class Interval
    attr_accessor :minutes,
                  :timer

    def initialize(minutes: nil)
      self.minutes = minutes
      self.timer = Minder::Timer.new(seconds: minutes * 60)
    end

    def start!
      timer.start!
    end

    def completed?
      timer.completed?
    end

    def message
      timer.to_s
    end
  end
end
