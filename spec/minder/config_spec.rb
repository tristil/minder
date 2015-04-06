require 'minder/config'
require 'tempfile'

describe Minder::Config do
  specify 'it sets location' do
    config = Minder::Config.new('location')
    expect(config.location).to eq('location')
  end

  describe '#load' do
    it 'loads values from a json file if it exists' do
      data = {
        work_duration: 15,
        short_break_duration: 10
      }
      json_file = Tempfile.new('minder json file')
      json_file.write(JSON.dump(data))
      json_file.seek(0)
      config = Minder::Config.new(json_file.path)
      config.load
      expect(config.data).to include(
        work_duration: 15,
        short_break_duration: 10,
        long_break_duration: 15)
    end

    it 'loads default values if no location is passed' do
      config = Minder::Config.new
      config.load
      expect(config.data).to include(
        work_duration: 25,
        short_break_duration: 5,
        long_break_duration: 15)
    end
  end

  describe 'auto-generated methods' do
    it 'creates a reader method for each default value key' do
      config = Minder::Config.new
      config.load
      expect(config.work_duration).to eq(25)
    end
  end
end
