require 'virtus'

module Minder
  class Period
    include Virtus.model

    attribute :id, Integer
    attribute :type, String
    attribute :started_at, DateTime
    attribute :ended_at, DateTime
    attribute :duration_in_seconds, Integer, default: 0
    attribute :completed, Boolean

    def duration_in_minutes=(minutes)
      self.duration_in_seconds = minutes.to_i * 60
    end

    def start!
      Minder.play_sound('start.wav')
      self.started_at = Time.now
    end

    def complete!
      Minder.play_sound('done.wav')
      self.ended_at = Time.now
      self.completed = true
    end

    def elapsed?
      elapsed_time >= duration_in_seconds
    end

    def message
      "#{Minder.formatted_time(elapsed_time)} " \
        "(out of #{Minder.formatted_time(duration_in_seconds)})"
    end

    def elapsed_time
      return 0 unless started_at
      return ended_at.to_i - started_at.to_i if ended_at

      (Time.now.to_time.to_i - started_at.to_time.to_i)
    end
  end
end
