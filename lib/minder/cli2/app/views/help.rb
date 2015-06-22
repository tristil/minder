module Cli2
  class HelpView < Vedeu::ApplicationView
    def initialize(*)
      super
      Vedeu.bind(:show_help) do
        Vedeu.trigger(:_show_interface_, 'help')
      end
    end

    def render
      Vedeu.renders do
        template_for('help', template('help'), object, options)
      end
    end

    private

    def options
      {}
    end

    def handle_keypress(key)
      return unless key
      changed
      notify_observers(:hide_help)
    end
  end
end
