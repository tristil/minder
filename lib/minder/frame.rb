require 'erb'
module Minder
  class Frame
    attr_accessor :window,
                  :width,
                  :object

    def initialize(height: nil, width: 40, top: nil, left: nil)
      self.width = width
      self.window = Curses::Window.new(height, width, top, left)
      window.box(?|, ?-)
    end

    def template
      raise NotImplementedError
    end

    def refresh
      b = binding
      ERB.new(template).result(b).split("\n").each_with_index do |line, index|
        window.setpos(index + 1, 1)
        print_line(line)
      end
      window.refresh
    end

    def print_line(text)
      remainder = width - 2 - text.length
      window.addstr(text + ' ' * remainder)
    end
  end
end
