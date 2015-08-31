require 'json'

module Minder
  class Config
    DEFAULTS = {
      work_duration: 25,
      short_break_duration: 5,
      long_break_duration: 15,
      emoji: 'tomato',
      database_name: 'database'
    }

    attr_accessor :location
    attr_reader :data

    def initialize(location = nil)
      self.location = location
      @data = {}
    end

    def load
      if File.exists?(location.to_s)
        file = File.open(location, 'r')
        @data = JSON.parse(file.read, symbolize_names: true)
      end
      DEFAULTS.each do |key, value|
        data[key] ||= DEFAULTS[key]
      end
    end

    DEFAULTS.keys.each do |key|
      define_method(key) do
        data[key]
      end
    end
  end
end
