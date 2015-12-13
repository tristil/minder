require 'rtasklib'

module Minder
  class TaskwarriorDatabase
    attr_reader :task_dir

    def initialize(task_dir:)
      @task_dir = task_dir
    end

    def tasks
      tw.all.map do |task|
        build_task(task)
      end
    end

    def tasks_filtered_by(text)
    end

    def add_task(text)
    end

    def delete_task(task)
    end

    def complete_task(task)
    end

    def start_task(task)
    end

    def unstart_task(task)
    end

    def update_task(task, options = {})
    end

    def complete_period(task)
    end

    def add_period(period)
    end

    def last_period
    end

    def update_period(period, options = {})
    end

    def periods
    end

    def pomodoros_today
    end

    private

    def build_task(tw_task)
      options = {
        id: tw_task.id,
        description: tw_task.description,
        completed_at: tw_task.end,
        started_at: tw_task.start
      }
      Minder::Task.new(options)
    end

    def tw
      @tw ||= Rtasklib::TW.new(task_dir)
    end
  end
end
