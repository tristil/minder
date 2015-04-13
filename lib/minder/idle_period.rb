require 'minder/period'

module Minder
  class IdlePeriod < Period
    def title
      "Press space to start next period"
    end

    def message
      ''
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
