module Cli2
  class QuickAddView < Vedeu::ApplicationView
    def render
      Vedeu.renders do
        template_for('quick_add', template('quick_add'), object, options)
      end
    end

    private

    def options
      {}
    end
  end
end
