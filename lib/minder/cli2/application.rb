require_relative 'config/configuration'
require_relative 'app/controllers/application_controller'

module Cli2
  class Application
    def self.start(**options)
      controller = Cli2::ApplicationController.new(options)
      Vedeu::Bootstrap.start(ARGV, controller)
    end
  end
end
