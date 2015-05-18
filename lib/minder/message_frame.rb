require 'minder/frame'

module Minder
  class MessageFrame < Frame
    attr_reader :current_line

    def initialize(*)
      super
      self.height = desired_height
    end

    def template
      if task_manager.tasks?
        doing_message
      else
        prompt_message
      end
    end

    def prompt_message
      <<-TEXT
What are you working on?

Press (e) to open editor.
TEXT
    end

    def header_text
<<-TEXT
Tasks         ? to see commands

TEXT
    end

    def tasks_text
      text = ''
      task_manager.tasks.each do |task|
         if task.started?
          text += "-[*] #{task}\n"
        else
          text += "-[ ] #{task}\n"
        end
      end
      text
    end

    def tasks_text_lines
      tasks_text.split("\n")
    end

    def header_text_lines
      header_text.split("\n")
    end

    def desired_height
      header_text_lines.length + tasks_text_lines.length + 3
    end

    def allocated_tasks_height
      height - header_text_lines.length
    end

    def offset_tasks_text
      tasks_text_lines[scroll_offset..(allocated_tasks_height + scroll_offset - 4)].join("\n")
    end

    def doing_message
      header_text +
        offset_tasks_text
    end

    def set_cursor_position
      window.setpos(3 + task_manager.selected_task_index - scroll_offset, 3)
    end

    def scroll_offset
      position = task_manager.selected_task_index + 5
      if height - position < 0
        (height - position).abs
      else
        0
      end
    end

    def handle_char_keypress(key)
      event = case key
      when 'j' then :select_next_task
      when 'k' then :select_previous_task
      when 'd' then :complete_task
      when 'x' then :delete_task
      when 's' then :start_task
      when 'u' then :unstart_task
      when 'G' then :select_last_task
      when 'e' then :editor
      when '?' then :help
      when '/' then :search
      when 'n' then :next_search
      when 'N' then :previous_search
      when 'g'
        @keypress_memory ||= []
        @keypress_memory << 'g'
        if @keypress_memory == ['g', 'g']
          @keypress_memory = []
          :select_first_task
        end
      end

      changed
      notify_observers(event)
    end
  end
end
