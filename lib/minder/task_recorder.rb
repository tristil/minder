module Minder
  class TaskRecorder
    attr_accessor :tasks

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
  end
end
