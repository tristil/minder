module Minder
  class TaskRecorder
    attr_accessor :tasks

    def initialize
      @selected_task_index = 0
    end

    def tasks
      File.read(DOING_FILE).split("\n")
    end

    def tasks?
      !tasks.empty?
    end

    def add_task(task)
      File.open(DOING_FILE, 'a') do |file|
        file.write("#{task}\n")
      end
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
  end
end
