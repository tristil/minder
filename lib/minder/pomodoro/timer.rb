module Minder
  class Timer
    attr_accessor :seconds,
                  :start_time

    def initialize(seconds: DEFAULT_WORK_PERIOD * 60)
      self.seconds = seconds
    end

    def start!
      self.start_time = Time.now
    end

    def completed?
      elapsed_time.to_i >= seconds
    end

    def elapsed_time
      return 0 unless start_time

      (Time.now - start_time)
    end

    def to_s
      "#{Minder.formatted_time(elapsed_time)} " \
        "(out of #{Minder.formatted_time(seconds)})"
    end
  end
end

