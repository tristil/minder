require_relative 'application_controller'
require_relative '../views/filter'

module Cli2

  class FilterController < Cli2::ApplicationController

    controller_name Cli2
    def initialize
      Cli2::FilterView.render(object)
    end

    private

    def object
      nil
    end

  end

end
