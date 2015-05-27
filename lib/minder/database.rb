require 'fileutils'
require "sqlite3"
require 'rom'
require 'rom-sql'

class Database
  attr_reader :rom

  def initialize
    FileUtils.mkdir_p(File.dirname(Minder::DATABASE_LOCATION))
    ROM.setup(:sql, "sqlite://#{Minder::DATABASE_LOCATION}")
    require 'minder/task'
    require 'minder/task_mapper'
    require 'minder/tasks'

    ROM.commands(:tasks) do
      define(:delete)
      define(:update)
    end

    @rom = ROM.finalize.env
  end

  def tasks
    rom.relation(:tasks).as(:entity).to_a
  end

  def tasks_filtered_by(text)
    rom.relation(:tasks).as(:entity).filtered_by(text).to_a
  end

  def add_task(description)
    rom.relations.tasks.insert(description: description)
  end

  def delete_task(task)
    rom.command(:tasks).delete.by_id(task.id).call
  end

  def start_task(task)
    rom.command(:tasks).update.by_id(task.id).call(started_at: Time.now)
  end

  def unstart_task(task)
    rom.command(:tasks).update.by_id(task.id).call(started_at: nil)
  end
end
