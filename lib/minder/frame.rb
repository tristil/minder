require 'erb'
module Minder
  class Frame
    attr_accessor :window,
                  :height,
                  :min_height,
                  :width,
                  :object

    def initialize(height: nil, width: 40, top: nil, left: nil, object: nil)
      self.object = object
      self.height = height
      self.min_height = height
      self.width = width
      self.window = Curses::Window.new(min_height, width, top, left)
    end

    def template
      raise NotImplementedError
    end

    def refresh
      window.box(?|, ?-)
      b = binding
      lines = ERB.new(template).result(b).split("\n")

      if lines.length >= min_height - 2
        self.height = lines.length + 2
      else
        self.height = min_height
      end
      window.resize(height, width)

      height.times do |index|
        next if index >= height - 2
        window.setpos(index + 1, 1)
        line = lines[index]
        if line
          print_line(line)
        else
          print_line('')
        end
      end
      window.refresh
    end

    def print_line(text)
      remainder = width - 2 - text.length
      window.addstr(text + ' ' * remainder)
    end
  end
end
