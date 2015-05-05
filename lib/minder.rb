module Minder
  DEFAULT_WORK_PERIOD = 25
  DEFAULT_BREAK_PERIOD = 5
  CONFIG_LOCATION = ENV['HOME'] + '/.minder.json'
  ASSETS_LOCATION = File.expand_path(File.dirname(__FILE__) + '/../assets')
  DOING_FILE = File.join(ENV["HOME"], '.minder', 'doing.txt')
  DONE_FILE = File.join(ENV["HOME"], '.minder', 'done.txt')
  def self.formatted_time(seconds)
    minutes = (seconds / 60).to_i
    seconds = (seconds % 60).round
    "#{'%02d' % minutes}:#{'%02d' % seconds}"
  end

  def self.play_sound(name)
    command = is_linux? ? 'aplay' : 'afplay'
    spawn("#{command} #{ASSETS_LOCATION}/#{name}",
          out: '/dev/null',
          err: '/dev/null')
  end

  def self.is_linux?
    RUBY_PLATFORM =~ /linux/
  end

  def self.pry_open(b)
    Curses.close_screen
    require 'pry'
    b.pry
  end
end
