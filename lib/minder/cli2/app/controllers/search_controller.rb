require_relative 'application_controller'
require_relative '../views/search'

module Cli2

  class SearchController < Cli2::ApplicationController

    controller_name Cli2
    def initialize
      Cli2::SearchView.render(object)
    end

    private

    def object
      nil
    end

  end

end
