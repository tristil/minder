require_relative 'application_controller'
require_relative '../views/help'

module Cli2

  class HelpController < Cli2::ApplicationController

    controller_name Cli2
    def initialize
      Cli2::HelpView.render(object)
    end

    private

    def object
      nil
    end

  end

end
