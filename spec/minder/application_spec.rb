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
    it 'runs the application' do
      config = instance_spy(
        'Minder::Config',
        work_duration: 'work_duration',
        short_break_duration: 'short_break_duration',
        long_break_duration: 'long_break_duration')
      application = Minder::Application.new(config: config)
      pomodoro_runner = instance_spy(Minder::PomodoroRunner)
      allow(Minder::PomodoroRunner).to receive(:new)
        .with(work_duration: 'work_duration',
              short_break_duration: 'short_break_duration',
              long_break_duration: 'long_break_duration')
        .and_return(pomodoro_runner)

      application.run

      expect(pomodoro_runner).to have_received(:run)
    end
  end
end
