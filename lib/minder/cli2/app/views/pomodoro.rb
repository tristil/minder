module Cli2
  class PomodoroView < Vedeu::ApplicationView
    def render
      Vedeu.render do
        template_for('pomodoro', template('pomodoro'), context, options)
      end
    end

    private

    def context
      OpenStruct.new(
        period: period,
        pomodoros: pomodoros,
        pomodoro_runner: pomodoro_runner,
        task_manager: task_manager
      )
    end

    def period
      pomodoro_runner.current_period
    end

    def pomodoros
      pomodoro_runner.pomodoros_today.map do |pomodoro|
        "\xF0\x9F\x8D\x85 "
      end.join
    end

    def pomodoro_runner
      object.fetch(:pomodoro_runner)
    end

    def task_manager
      object.fetch(:task_manager)
    end

    def options
      {}
    end
  end
end
