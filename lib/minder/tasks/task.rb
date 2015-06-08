require 'virtus'

module Minder
  class Task
    include Virtus.model

    attribute :id, Integer
    attribute :description, String
    attribute :selected, Boolean
    attribute :started_at, DateTime
    attribute :completed_at, DateTime

    def started?
      !!started_at
    end

    def to_s
      description.gsub(/\A\* /, '')
    end
  end
end
