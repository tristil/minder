module Minder
  class TaskRecorder
    attr_accessor :tasks

    def tasks
      File.read(DOING_FILE).split("\n")
    end

    def tasks?
      !tasks.empty?
    end
  end
end
