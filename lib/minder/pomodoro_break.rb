module Minder
  class PomodoroBreak
    attr_accessor :minutes

    def initialize(minutes: DEFAULT_WORK_PERIOD)
      self.minutes = minutes
    end

    def run
      timer = Minder::Timer.new(seconds: minutes * 60)
      timer.start!
      puts "Break period"
      puts ""
      while !timer.completed?
        timer.tick
        $stdout.flush
        print "#{timer}\r"
      end
    end
  end
end
