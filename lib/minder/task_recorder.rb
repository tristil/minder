require 'minder/task'
require 'fileutils'

module Minder
  class TaskRecorder
    attr_accessor :tasks,
                  :lines

    def initialize
      @selected_task_index = 0
      reload
    end

    def tasks
      @tasks ||= lines.map { |task| Task.new(description: task) }
    end

    def tasks?
      !tasks.empty?
    end

    def add_task(task)
      File.open(DOING_FILE, 'a') do |file|
        file.write("#{task}\n")
      end
      reload
    end

    def select_next_task
      if @selected_task_index + 1 <= tasks.length - 1
        @selected_task_index += 1
      else
        @selected_task_index = 0
      end
    end

    def select_previous_task
      if @selected_task_index == 0
        @selected_task_index = tasks.length - 1
      else
        @selected_task_index -= 1
      end
    end

    def selected_task_index
      @selected_task_index
    end

    def selected_task
      tasks[selected_task_index]
    end

    def delete_task
      lines.delete_at(selected_task_index)
      @tasks = nil
      write_file_with_backup
      reload

      select_previous_task
    end

    def reload
      self.lines = File.read(DOING_FILE).strip.split("\n")
      @tasks = nil
    end

    def complete_task
      task = selected_task
      delete_task
      add_to_done_file("Finished: #{task.description}")
    end

    def add_to_done_file(text)
      File.open(DONE_FILE, 'a') do |file|
        file.write("[#{Time.now.strftime('%Y-%m-%d %H:%M:%S')}] #{text}\n")
      end
    end

    def write_file_with_backup
      FileUtils.cp(DOING_FILE, DOING_FILE + '.old')
      write_file(DOING_FILE)
    end

    def write_file(path)
      File.open(path, 'w') do |file|
        tasks.each do |task|
          line = task.to_s
          line = "* #{line}" if task.started?
          file.write("#{line}\n")
        end
      end
    end

    def start_task
      selected_task.start
      write_file_with_backup
      add_to_done_file("Started: #{selected_task.description}")
      reload
    end

    def unstart_task
      selected_task.unstart
      write_file_with_backup
      add_to_done_file("Un-started: #{selected_task.description}")
      reload
    end

    def started_task
      tasks.find(&:started?)
    end
  end
end
