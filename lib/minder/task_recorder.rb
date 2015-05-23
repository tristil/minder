require 'minder/task'
require 'fileutils'

module Minder
  class TaskRecorder
    attr_accessor :tasks,
                  :lines

    attr_reader :search_results,
                :unfiltered_tasks

    def initialize
      @selected_task_index = 0
      @selected_search_result = 0
      @search_results = []
      @filter = ''
      reload
    end

    def filter(text)
      @tasks = nil
      @filter = text
    end

    def tasks
      @tasks ||= build_filtered_tasks
    end

    def build_filtered_tasks
      build_tasks.select do |task|
        task.description.downcase.include?(@filter.downcase)
      end
    end

    def unfiltered_tasks
      @unfiltered_tasks ||= build_tasks
    end

    def build_tasks
      lines.map { |task| Task.new(description: task) }
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
      @unfiltered_tasks = nil
      write_file_with_backup
      reload

      select_previous_task
    end

    def reload
      self.lines = File.read(DOING_FILE).strip.split("\n")
      @tasks = nil
      @unfiltered_tasks = nil
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
        unfiltered_tasks.each do |task|
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

    def select_last_task
      @selected_task_index = tasks.length - 1
    end

    def select_first_task
      @selected_task_index = 0
    end

    def search(text)
      @search_results = tasks.select do |task|
        task.description.downcase.include?(text.downcase)
      end
      @selected_search_result = 0
    end

    def select_search_result(search_index = 0)
      return if search_results.empty?

      @selected_task_index = tasks.find_index do |task|
        task.description == search_results[search_index].description
      end
    end

    def next_search
      @selected_search_result += 1

      if @selected_search_result > search_results.length - 1
        @selected_search_result = 0
      end
      select_search_result(@selected_search_result)
    end

    def previous_search
      @selected_search_result -= 1

      if @selected_search_result < 0
        @selected_search_result = search_results.length - 1
      end

      select_search_result(@selected_search_result)
    end
  end
end
