require 'minder/timer'
require 'timecop'

describe Minder::Timer do
  after do
    Timecop.return
  end

  describe '#initialize' do
    it 'sets seconds' do
      expect(Minder::Timer.new(seconds: 30).seconds).to eq(30)
    end

    it 'sets seconds to 25 minutes by default' do
      expect(Minder::Timer.new.seconds).to eq(25 * 60)
    end
  end

  describe '#start!' do
    it 'sets the start time' do
      now = Time.new(2015, 5, 1, 12, 30)
      Timecop.freeze(now)
      minder = Minder::Timer.new
      minder.start!
      Timecop.return

      later = Time.new(2015, 5, 1, 13, 0)
      Timecop.travel(later)
      expect(minder.start_time).to eq(now)
    end
  end

  describe '#completed?' do
    it "is false if the passed seconds hasn't elapsed yet" do
      now = Time.new(2015, 5, 1, 12, 30)
      Timecop.freeze(now)
      minder = Minder::Timer.new(seconds: 10 * 60)
      minder.start!
      Timecop.return

      later = Time.new(2015, 5, 1, 12, 39)
      Timecop.travel(later)
      expect(minder.completed?).to eq(false)
    end

    it "is true if the passed seconds has already elapsed" do
      now = Time.new(2015, 5, 1, 12, 30)
      Timecop.freeze(now)
      minder = Minder::Timer.new(seconds: 10 * 60)
      minder.start!
      Timecop.return

      later = Time.new(2015, 5, 1, 12, 41)
      Timecop.travel(later)
      expect(minder.completed?).to eq(true)
    end
  end

  describe '#elapsed_time' do
    it 'is 0 if start has not been called' do
      now = Time.new(2015, 5, 1, 12, 30, 10)
      Timecop.freeze(now)
      minder = Minder::Timer.new(seconds: 10 * 60)
      Timecop.return

      later = Time.new(2015, 5, 1, 12, 30, 30)
      Timecop.travel(later)
      expect(minder.elapsed_time).to eq(0)
    end

    it 'is the number of seconds from the start time to the end time' do
      now = Time.new(2015, 5, 1, 12, 30, 10)
      Timecop.freeze(now)
      minder = Minder::Timer.new(seconds: 10 * 60)
      minder.start!
      Timecop.return

      later = Time.new(2015, 5, 1, 12, 30, 30)
      Timecop.travel(later)
      expect(minder.elapsed_time).to be_within(1).of(20)
    end
  end
end
