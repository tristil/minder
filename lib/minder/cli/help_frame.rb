require 'minder/cli/frame'

module Minder
  class HelpFrame < Frame
    def template
      <<-TEXT
Commands:   any key to dismiss

(s) start task
(u) un-start task
(d) mark task as done
(x) delete task
(e) edit task
(G) go to bottom of list
(gg) go to top of list
(/) Search among tasks
(m) minimize messages frame
(n) Next search result
(N) Previous search result
(?) to view this text
      TEXT
    end

    def desired_height
      template.split("\n").length + 2
    end

    def handle_keypress(key)
      return unless key
      changed
      notify_observers(:hide_help)
    end
  end
end
