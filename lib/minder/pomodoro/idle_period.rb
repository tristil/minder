require 'minder/pomodoro/period'

module Minder
  class IdlePeriod < Period
    def title
      "Press space to start next period"
    end

    def message
      nil
    end

    def start!
      self.started_at = Time.now
    end

    def complete!
      self.ended_at = Time.now
    end

    def elapsed?
      true
    end

    def completed?
      true
    end

    def type
      'idle'
    end
  end
end
