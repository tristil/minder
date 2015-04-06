module Minder
  DEFAULT_WORK_PERIOD = 25 * 60
  CONFIG_LOCATION = ENV['HOME'] + '/.minder.json'

  def self.formatted_time(seconds)
    minutes = (seconds / 60).to_i
    seconds = (seconds % 60).round
    "#{'%02d' % minutes}:#{'%02d' % seconds}"
  end
end
