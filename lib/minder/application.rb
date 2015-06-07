require 'minder/config'
require 'minder/pomodoro_runner'
require 'minder/task_manager'
require 'minder/scene'
require 'active_support'
require 'curses'
require 'fileutils'

module Minder
  class Application
    attr_accessor :config,
                  :scene,
                  :pomodoro_frame,
                  :help_frame,
                  :search_frame,
                  :filter_frame,
                  :message_frame,
                  :quick_add_frame

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
      pomodoro_runner.add_observer(self, :handle_event)

      self.scene = Scene.new
      scene.setup

      options = { pomodoro_runner: pomodoro_runner, task_manager: task_manager  }

      self.pomodoro_frame = PomodoroFrame.new(options)
      self.help_frame = HelpFrame.new(options)
      help_frame.hide
      self.filter_frame = FilterFrame.new(options)
      filter_frame.hide
      self.search_frame = SearchFrame.new(options)
      search_frame.hide
      self.message_frame = MessageFrame.new(options)
      self.quick_add_frame = QuickAddFrame.new(options)
      quick_add_frame.focus

      scene.frames << pomodoro_frame
      scene.frames << message_frame
      scene.frames << help_frame
      scene.frames << filter_frame
      scene.frames << search_frame
      scene.frames << quick_add_frame

      scene.frames.each do |frame|
        frame.add_observer(self, :handle_event)
      end

      # TODO: Eww, gross
      scene.redraw
      scene.redraw

      old_dimensions = [Curses.lines, Curses.cols]
      loop do
        scene.frames.each do |frame|
          next unless frame.focused?
          frame.listen
        end
        pomodoro_runner.tick
        pomodoro_frame.refresh
        scene.focused_frame.set_cursor_position
        scene.focused_frame.window_refresh

        new_dimensions = [Curses.lines, Curses.cols]
        if new_dimensions != old_dimensions
          scene.redraw
          scene.redraw
          old_dimensions = new_dimensions
        end

        sleep(0.01)
      end

      scene.close
    end

    def pomodoro_runner
      @runner ||= PomodoroRunner.new(
        work_duration: config.work_duration,
        short_break_duration: config.short_break_duration,
        long_break_duration: config.long_break_duration)
    end

    def task_manager
      @task_manager ||= TaskManager.new(database: database)
    end

    def handle_event(event, data = {})
      return unless event

      case event
      when :started_work
        message_frame.minimize
      when :completed_work
        message_frame.unminimize
      when :continue
        pomodoro_runner.continue
      when :editor
        `$EDITOR ~/.minder/doing.txt`
        task_manager.reload
      when :add_task
        task_manager.add_task(data[:task])
      when :switch_focus
        scene.switch_focus
      when :select_next_task
        task_manager.select_next_task
      when :select_previous_task
        task_manager.select_previous_task
      when :delete_task
        task_manager.delete_task
      when :complete_task
        task_manager.complete_task
      when :start_task
        task_manager.start_task
      when :unstart_task
        task_manager.unstart_task
      when :select_last_task
        task_manager.select_last_task
      when :select_first_task
        task_manager.select_first_task
      when :help
        message_frame.hide
        help_frame.unhide
        scene.focus_frame(help_frame)
      when :hide_help
        help_frame.hide
        message_frame.unhide
        scene.focus_frame(message_frame)
      when :open_filter
        filter_frame.unhide
        scene.focus_frame(filter_frame)
      when :submit_filter
        filter_frame.hide if data[:text] == ''
        scene.focus_frame(message_frame)
      when :update_filter
        task_manager.filter(data[:text])
      when :search
        search_frame.unhide
        search_frame.begin_search
        scene.focus_frame(search_frame)
      when :submit_search
        search_frame.hide
        scene.focus_frame(message_frame)
        task_manager.search(data[:text])
        task_manager.select_search_result
      when :next_search
        task_manager.next_search
      when :previous_search
        task_manager.previous_search
      when :escape_search
        search_frame.hide
        scene.focus_frame(message_frame)
      end

      scene.redraw
      scene.redraw
    end
  end
end
