require 'minder/timer'

module Minder
  class Interval
    attr_accessor :minutes

    def initialize(minutes: nil)
      self.minutes = minutes
    end

    def run
      timer = Minder::Timer.new(seconds: minutes * 60)
      timer.start!
      puts message
      puts ""
      while !timer.completed?
        timer.tick
        $stdout.flush
        print "#{timer}\r"
      end
    end
  end
end
