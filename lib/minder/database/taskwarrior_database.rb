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
      tw.some(dom: { description: text }).map do |task|
        build_task(task)
      end
    end

    def add_task(text)
      tw.add!(text)
    end

    def delete_task(task)
      tw.delete!(ids: task.id)
    end

    def complete_task(task)
      tw.done!(ids: task.id)
    end

    def start_task(task)
      tw.start!(ids: task.id)
    end

    def unstart_task(task)
      tw.stop!(ids: task.id)
    end

    def update_task(task, options = {})
      options.each do |key, value|
        tw.modify!(key, value, ids: task.id)
      end
    end

    def complete_period(task)
    end

    def add_period(period)
    end

    def last_period
      Minder::IdlePeriod.new({})
    end

    def update_period(period, options = {})
    end

    def periods
      []
    end

    def pomodoros_today
      []
    end

    private

    def build_task(tw_task)
      options = {
        id: tw_task.uuid,
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
