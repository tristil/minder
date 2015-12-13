require 'spec_helper'
require 'fileutils'

require 'minder/tasks/task'
require 'minder/database/taskwarrior_database'

describe Minder::TaskwarriorDatabase do
  let(:task_dir) { SPEC_DIR + '/fixtures/.task' }
  let(:database) { described_class.new(task_dir: task_dir) }
  let(:tw) { Rtasklib::TW.new(task_dir) }

  before(:each) do
    FileUtils.rm_f "#{task_dir}/pending.data"
    FileUtils.rm_f "#{task_dir}/completed.data"
    FileUtils.rm_f "#{task_dir}/undo.data"
    FileUtils.rm_f "#{task_dir}/backlog.data"
  end

  specify '#tasks returns an empty list of tasks if empty' do
    expect(database.tasks).to eq([])
  end

  specify '#tasks returns an array of tasks if present' do
    tw.add!('A sample task', tags: %w(test test2), dom: ['project:spec'])
    tasks = database.tasks
    expect(tasks.length).to eq(1)
    expect(tasks[0].description).to eq('A sample task')
  end
end
