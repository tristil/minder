require 'minder/timer'

module Minder
  class Period
    attr_accessor :minutes,
                  :timer

    def initialize(minutes: nil)
      self.minutes = minutes
      self.timer = Minder::Timer.new(seconds: minutes.to_i * 60)
    end

    def start!
      Minder.play_sound('start.wav')
      timer.start!
    end

    def complete!
      Minder.play_sound('done.wav')
      @status = :completed
    end

    def completed?
      @status == :completed
    end

    def elapsed?
      timer.completed?
    end

    def message
      timer.to_s
    end
  end
end
