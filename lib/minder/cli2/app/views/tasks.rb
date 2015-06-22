module Cli2
  class TasksView < Vedeu::ApplicationView
    def initialize(*)
      super
      @minimized = false
      @editing = false

      Vedeu.bind(:show_help) do
        Vedeu.trigger(:_hide_interface_, 'tasks')
      end
    end

    def minimize
      @minimized = true
    end

    def unminimize
      @minimized = false
    end

    def minimized?
      @minimized
    end

    def editing?
      @editing
    end

    def render
      Vedeu.renders do
        if minimized?
          view 'tasks' do
            lines do
              line 'Space to see tasks'
            end
          end
        else
          template_for('tasks', template('tasks'), context, options)
        end
      end
    end

    private

    def context
      OpenStruct.new(
        task_manager: object[:task_manager]
      )
    end

    def options
      {}
    end
  end
end
