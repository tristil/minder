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
    end

    def config_location
      config.location
    end

    def run
      pomodoro_runner.add_observer(self, :respond_to_event)

      self.scene = Scene.new
      scene.setup

      scene.frames << PomodoroFrame.new(
        object: pomodoro_runner,
        height: 5,
        width: 40,
        top: 0,
        left: 0)

      scene.frames << MessageFrame.new(
        object: task_recorder,
        height: 5,
        width: 40,
        top: 7,
        left: 0)

      loop do
        pomodoro_runner.tick

        char_code = get_keycode
        event = event_from_keycode(char_code)

        resolution = handle_event(event)

        scene.update
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

    def get_keycode
      char = Curses.getch
      char && char.ord
    end

    def handle_event(event)
      if event == :continue
        pomodoro_runner.continue
      elsif event == :editor
        `editor ~/.minder/doing.txt`
        scene.close
        scene.setup
      end
    end

    def event_from_keycode(keycode)
      case keycode
      when 3 then :exit
      when 32 then :continue
      when 101 then :editor
      end
    end

    def respond_to_event(event)
    end
  end
end
