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
      # noop
    end

    def elapsed?
      true
    end

    def completed?
      true
    end
  end
end
