require 'minder/config'
require 'minder/pomodoro_runner'
require 'minder/task_recorder'
require 'minder/scene'

require 'curses'

module Minder
  class Application
    attr_accessor :config,
                  :scene

    def initialize(config: Minder::Config.new(CONFIG_LOCATION))
      self.config = config
      config.load
    end

    def config_location
      config.location
    end

    def run
      pomodoro_runner.add_observer(self, :respond_to_event)

      self.scene = Scene.new
      scene.setup

      loop do
        pomodoro_runner.tick

        char_code = get_keycode
        event = event_from_keycode(char_code)

        resolution = handle_event(event)

        scene.action = pomodoro_runner.current_action
        scene.tasks = task_recorder.tasks
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
      end
    end

    def event_from_keycode(keycode)
      case keycode
      when 3 then :exit
      when 32 then :continue
      end
    end

    def respond_to_event(event)
    end
  end
end
