require 'minder/cli/frame'
require 'minder/cli/task_editor'

module Minder
  class TasksFrame < Frame
    attr_reader :current_line,
                :task_editor

    def setup
      interface 'tasks' do
        border do
          'C'
        end
        geometry do
          y { use('pomodoro').south }
          yn { use('quick_add').north }
        end
        cursor!
        group 'main'
      end

      keymap 'tasks' do
        key(:up, 'k') { Vedeu.trigger(:_cursor_up_) }
        key(:down, 'j') { Vedeu.trigger(:_cursor_down_) }
      end
    end

    def initialize(*)
      super
      self.height = desired_height
      @minimized = false
      @editing = false
    end

    def minimize
      @minimized = true
    end

    def unminimize
      @minimized = false
      self.height = desired_height
    end

    def minimized?
      @minimized
    end

    def editing?
      @editing
    end

    def template
      if minimized?
        minimized_message
      elsif task_manager.tasks?
        doing_message
      else
        prompt_message
      end
    end

    def minimized_message
<<-TEXT
Space to see tasks
TEXT
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

    def view_name
      'tasks'
    end

    def tasks_text_lines
      tasks_text.split("\n")
    end

    def header_text_lines
      header_text.split("\n")
    end

    def desired_height
      return 3 if minimized?

      # TODO: figure out what this magic 3 number is
      header_text_lines.length + tasks_text_lines.length + 3
    end

    def allocated_tasks_height
      height - header_text_lines.length - 3
    end

    def offset_tasks_text
      tasks_text_lines[visible_tasks_range].join("\n")
    end

    def visible_tasks_range
      (scroll_offset..(allocated_tasks_height + scroll_offset - 1))
    end

    def doing_message
      header_text +
        offset_tasks_text
    end

    def set_cursor_position
      if minimized?
        window.setpos(1, 20)
      elsif editing?
        window.setpos(3 + task_manager.selected_task_index - scroll_offset,
                      task_editor.cursor_position + 6)
      else
        window.setpos(3 + task_manager.selected_task_index - scroll_offset, 3)
      end
    end

    def total_tasks_height
      task_manager.tasks.length
    end

    def scroll_offset
      position = task_manager.selected_task_index + 1
      if position > allocated_tasks_height
        position - allocated_tasks_height
      else
        0
      end
    end

    def handle_keypress(key)
      if editing?
        task_editor.handle_keypress(key)
      else
        super
      end
    end

    def handle_task_editor_event(event, data = {})
      if event == :stop_editing
        @editing = false
        @task_editor = nil
      elsif event == :update_task
        task_manager.update_task(task_manager.selected_task, data)
        @editing = false
        @task_editor = nil
      end

      changed
      notify_observers(event)
    end

    def handle_char_keypress(key)
      event =
        case key
        when 'j' then :select_next_task
        when 'k' then :select_previous_task
        when 'd' then :complete_task
        when 'x' then :delete_task
        when 's' then :start_task
        when 'u' then :unstart_task
        when 'G' then :select_last_task
        when 'e'
          @editing = true
          @task_editor = TaskEditor.new(task_manager.selected_task, self)
          @task_editor.add_observer(self, :handle_task_editor_event)
          :edit_task
        when '?' then :help
        when '/' then :search
        when 'm'
          minimize
          :redraw
        when 'n' then :next_search
        when 'N' then :previous_search
        when 'f' then :open_filter
        when 'g'
          @keypress_memory ||= []
          @keypress_memory << 'g'
          if @keypress_memory == ['g', 'g']
            @keypress_memory = []
            :select_first_task
          end
        when ' '
          if minimized?
            unminimize
            :redraw
          end
        end

      changed
      notify_observers(event)
    end
  end
end
