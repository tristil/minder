require "sqlite3"
require 'rom'
require 'rom-sql'
require 'logger'

class Database
  attr_reader :rom

  def initialize
    FileUtils.mkdir_p(File.dirname(Minder::DATABASE_LOCATION))
    ROM.setup(:sql, "sqlite://#{Minder::DATABASE_LOCATION}")

    require 'minder/tasks/task'
    require 'minder/database/task_mapper'
    require 'minder/database/tasks'
    require 'minder/database/period_mapper'
    require 'minder/database/periods'

    ROM.commands(:tasks) do
      define(:delete)
      define(:update)
    end

    ROM.commands(:periods) do
      define(:update)
    end

    @rom = ROM.finalize.env
    rom.repositories[:default].use_logger(Logger.new(Minder::LOG_LOCATION))
  end

  def tasks
    rom.relation(:tasks).active.as(:entity).to_a
  end

  def tasks_filtered_by(text)
    rom.relation(:tasks).active.as(:entity).filtered_by(text).to_a
  end

  def add_task(description)
    rom.relations.tasks.insert(description: description)
  end

  def delete_task(task)
    rom.command(:tasks).delete.by_id(task.id).call
  end

  def complete_task(task)
    update_task(task, completed_at: Time.now)
  end

  def start_task(task)
    update_task(task, started_at: Time.now)
  end

  def unstart_task(task)
    update_task(task, started_at: nil)
  end

  def update_task(task, options = {})
    rom.command(:tasks).update.by_id(task.id).call(options)
  end

  def complete_period(task)
    update_period(task, ended_at: Time.now)
  end

  def add_period(period)
    rom.relations.periods.insert(started_at: period.started_at,
                                 type: period.type)
  end

  def last_period
    require 'minder/pomodoro/work_period'
    require 'minder/pomodoro/break_period'
    require 'minder/pomodoro/idle_period'
    data = rom.relations.periods.last
    if data[:type] == 'work'
      Minder::WorkPeriod.new(data)
    elsif data[:type] == 'break'
      Minder::BreakPeriod.new(data)
    else
      Minder::IdlePeriod.new(data)
    end
  end

  def update_period(period, options = {})
    rom.command(:periods).update.by_id(period.id).call(options)
  end

  def periods
    rom.relation(:tasks).active.as(:entity).to_a
  end

  def pomodoros_today
    rom.relation(:periods).pomodoros_today.as(:entity).to_a
  end
end
