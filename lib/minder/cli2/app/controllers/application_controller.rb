require_relative '../views/pomodoro'
require_relative '../views/tasks'
require_relative '../views/quick_add'
require_relative '../views/help'
require_relative '../views/search'
require_relative '../views/filter'

module Cli2
  class ApplicationController < Vedeu::ApplicationController
    def initialize(**options)
      Cli2::PomodoroView.render(options)
      Cli2::TasksView.render(options)
      Cli2::QuickAddView.render(options)
      Cli2::FilterView.render(options)
      Cli2::SearchView.render(options)
      Cli2::HelpView.render(options)
    end
  end
end
