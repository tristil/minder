require 'ostruct'
require 'minder/help_frame'
require 'minder/search_frame'
require 'minder/pomodoro_frame'
require 'minder/message_frame'
require 'minder/quick_add_frame'

module Minder
  class Scene
    attr_accessor :frames

    def initialize
      self.frames = []
    end

    def setup
      Curses.noecho
      Curses.init_screen
      Curses.timeout = 0
      clear
      Curses.refresh
    end

    def focused_frame
      frames.find(&:focused?)
    end

    def switch_focus
      current_index = frames.find_index(focused_frame)
      focused_frame.unfocus
      next_frame = frames[current_index + 1..-1].find { |frame| !frame.hidden? }
      if next_frame
        next_frame.focus
      else
        frames[0].focus
      end
    end

    def focus_frame(frame)
      focused_frame.unfocus
      frame.focus
    end

    def refresh
      frames.map(&:refresh)
    end

    def resize_frames
      frames.map(&:resize)
      first_frame = frames[0]
      last_frame = frames.last

      available_height = Curses.lines - last_frame.height

      first_frame.move(0, 0)
      next_height = first_frame.height

      previous_frame_height = next_height

      middle_frames = frames[1...-1]
      middle_frames.each do |frame|
        unless frame.hidden?
          proposed_height = available_height - previous_frame_height

          if proposed_height < frame.min_height
            proposed_height = frame.min_height
          end

          if proposed_height < frame.desired_height
            frame.height = proposed_height
          else
            frame.height = frame.desired_height
          end
          frame.move(next_height, 0)
          previous_frame_height = frame.height
          next_height += frame.height
        end
      end

      if next_height <= available_height
        frames.last.move(next_height, 0)
      else
        frames.last.move(available_height, 0)
      end
    end

    def redraw
      refresh
      resize_frames
      refresh
      Curses.curs_set(1)
      focused_frame.set_cursor_position
      focused_frame.window_refresh
    end

    def clear
      Curses.clear
    end

    def close
      Curses.close_screen
    end
  end
end
