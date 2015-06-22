require 'minder/config'
require 'minder/pomodoro/pomodoro_runner'
require 'minder/tasks/task_manager'

require 'ostruct'

require 'vedeu'
require 'minder/cli2/application'

#require 'minder/cli/setup'
#require 'minder/cli/scene'
#require 'minder/cli/views/help_frame'
#require 'minder/cli/views/search_frame'
#require 'minder/cli/views/filter_frame'
#require 'minder/cli/views/pomodoro_frame'
#require 'minder/cli/views/tasks_frame'
#require 'minder/cli/views/quick_add_frame'

module Minder
  class Application
    attr_accessor :config

    attr_reader :database

    def initialize(config: Minder::Config.new(CONFIG_LOCATION),
                   database: Database.new)
      @database = database
      self.config = config
      config.load
      FileUtils.mkdir_p(File.join(ENV['HOME'], '.minder'))
      FileUtils.touch(DOING_FILE)
      FileUtils.touch(DONE_FILE)
    end

    def config_location
      config.location
    end

    def run
      #pomodoro_runner.add_observer(self, :handle_event)
      Cli2::Application.start(
        pomodoro_runner: pomodoro_runner,
        task_manager: task_manager)
    end

    def pomodoro_runner
      @runner ||= PomodoroRunner.new(
        work_duration: config.work_duration,
        short_break_duration: config.short_break_duration,
        long_break_duration: config.long_break_duration,
        database: database)
    end

    def task_manager
      @task_manager ||= TaskManager.new(database: database)
    end

    #def handle_event(event, data = {})
      #return unless event

      #case event
      #when :started_work
        #tasks_frame.minimize
      #when :completed_work
        #tasks_frame.unminimize
      #when :continue
        #pomodoro_runner.continue
      #when :editor
        #`$EDITOR ~/.minder/doing.txt`
        #task_manager.reload
      #when :add_task
        #task_manager.add_task(data[:task])
      #when :switch_focus
        #scene.switch_focus
      #when :select_next_task
        #task_manager.select_next_task
      #when :select_previous_task
        #task_manager.select_previous_task
      #when :delete_task
        #task_manager.delete_task
      #when :complete_task
        #task_manager.complete_task
      #when :start_task
        #task_manager.start_task
      #when :unstart_task
        #task_manager.unstart_task
      #when :select_last_task
        #task_manager.select_last_task
      #when :select_first_task
        #task_manager.select_first_task
      #when :help
        #tasks_frame.hide
        #help_frame.unhide
        #scene.focus_frame(help_frame)
      #when :hide_help
        #help_frame.hide
        #tasks_frame.unhide
        #scene.focus_frame(tasks_frame)
      #when :open_filter
        #filter_frame.unhide
        #scene.focus_frame(filter_frame)
      #when :submit_filter
        #filter_frame.hide if data[:text] == ''
        #scene.focus_frame(tasks_frame)
      #when :update_filter
        #task_manager.filter(data[:text])
      #when :search
        #search_frame.unhide
        #search_frame.begin_search
        #scene.focus_frame(search_frame)
      #when :submit_search
        #search_frame.hide
        #scene.focus_frame(tasks_frame)
        #task_manager.search(data[:text])
        #task_manager.select_search_result
      #when :next_search
        #task_manager.next_search
      #when :previous_search
        #task_manager.previous_search
      #when :escape_search
        #search_frame.hide
        #scene.focus_frame(tasks_frame)
      #end

      #scene.redraw
      #scene.redraw
    #end
  end
end
