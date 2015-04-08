require 'minder/application'
require 'tempfile'

describe Minder::Application do
  let(:config_file) do
    Tempfile.new('minder config')
  end

  describe '#initialize' do
    it 'sets the config' do
      config = instance_spy('Minder::Config')
      application = Minder::Application.new(config: config)
      expect(application.config).to eq(config)
    end
  end

  specify '#config_location is delegated to the config' do
    config = instance_spy('Minder::Config', location: 'location')
    application = Minder::Application.new(config: config)
    expect(application.config_location).to eq('location')
  end

  describe '#run' do
    let(:config) do
      instance_spy(
        'Minder::Config',
        work_duration: 'work_duration',
        short_break_duration: 'short_break_duration',
        long_break_duration: 'long_break_duration')
    end
    let(:application) { Minder::Application.new(config: config) }

    it 'runs the application' do
      pomodoro_runner = instance_double(Minder::PomodoroRunner)
      allow(Minder::PomodoroRunner).to receive(:new)
        .with(work_duration: 'work_duration',
              short_break_duration: 'short_break_duration',
              long_break_duration: 'long_break_duration')
        .and_return(pomodoro_runner)
      allow(application).to receive(:system)
      allow(application).to receive(:puts)
      allow(STDIN).to receive(:getc).and_return(' ')
      interval = instance_double(Minder::Interval)
      allow(pomodoro_runner).to receive(:next_action).and_return(interval)

      application.run

      expect(application).to have_received(:system).with('stty raw -echo')
      expect(application).to have_received(:system).with('stty -raw echo')
      expect(STDIN).to have_received(:getc).with('stty -raw echo')
      expect(pomodoro_runner).to have_received(:next_action)
      expect(interval).to receive(:)
    end
  end
end
