require 'minder/config'
require 'minder/pomodoro_runner'
require 'minder/task_recorder'
require 'minder/scene'

require 'curses'
require 'fileutils'

module Minder
  class Application
    attr_accessor :config,
                  :scene

    def initialize(config: Minder::Config.new(CONFIG_LOCATION))
      self.config = config
      config.load
      FileUtils.mkdir_p(File.join(ENV['HOME'], '.minder'))
      FileUtils.touch(DOING_FILE)
    end

    def config_location
      config.location
    end

    def run
      pomodoro_runner.add_observer(self, :handle_event)

      self.scene = Scene.new
      scene.setup

      pomodoro_frame = PomodoroFrame.new(object: pomodoro_runner)
      scene.frames << pomodoro_frame
      scene.frames << MessageFrame.new(object: task_recorder)
      quick_add_frame = QuickAddFrame.new(object: task_recorder)
      quick_add_frame.focus
      scene.frames << quick_add_frame

      scene.frames.each do |frame|
        frame.add_observer(self, :handle_event)
      end

      loop do
        pomodoro_runner.tick
        scene.update
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

    def task_recorder
      @task_recorder ||= TaskRecorder.new
    end

    def handle_event(event, data = {})
      return unless event

      case event
      when :continue
        pomodoro_runner.continue
      when :editor
        `$EDITOR ~/.minder/doing.txt`
        scene.close
        scene.setup
      when :add_task
        task_recorder.add_task(data[:task])
      when :switch_focus
        scene.switch_focus
      end
    end
  end
end
