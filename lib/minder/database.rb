require "sqlite3"
require 'rom'
require 'rom-sql'

class Database
  attr_reader :rom

  def initialize
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
end
