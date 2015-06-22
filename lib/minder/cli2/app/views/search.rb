module Cli2

  class SearchView < Vedeu::ApplicationView

    def render
      Vedeu.renders do

        # Build up the view programmatically...
        #
        # view 'search' do
        #   lines do
        #     line 'some content...'
        #   end
        # end

        # ...or use the template in 'app/views/templates/search'
        #
        template_for('search',
                     template('search'),
                     object,
                     options)
      end
    end

    private

    def options
      {}
    end

  end

end
