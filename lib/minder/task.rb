require 'virtus'

module Minder
  class Task
    include Virtus.model

    attribute :id, Integer
    attribute :description, String
    attribute :selected, Boolean, default: false
    attribute :started, Boolean, default: false

    def start
      self.started = true
    end

    def unstart
      self.description.gsub!(/\* /, '')
      self.started = false
    end

    def started?
      super || description =~ /\* /
    end

    def to_s
      description.gsub(/\A\* /, '')
    end
  end
end
