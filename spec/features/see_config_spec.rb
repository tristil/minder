require 'colorize'

describe 'See current config options', type: :aruba do
  before do
    set_env 'LINES', '10'
    set_env 'COLUMNS', '10'
    set_env 'HOME', File.expand_path(current_directory)
  end

  it 'shows the config options with --config' do
    run_interactive 'bundle exec minder --config'
    chunk = nil
    Timeout.timeout(exit_timeout) do
      loop do
        chunk = unescape(_read_interactive)
        break if chunk != ''
        sleep 0.1
      end
    end
    type "\u0003".encode('utf-8')
    expect(chunk.uncolorize).to eq('')
  end

  after do
    restore_env
    require 'curses'
    Curses.close_screen
  end
end
