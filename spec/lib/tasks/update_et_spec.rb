require_relative '../../../lib/tasks/update_et'
require 'rake'

describe Tasks::UpdateEt, :slow do

  before(:all) do
    @update_et = Tasks::UpdateEt.new 'http://weather2.nmsu.edu/wx-stn-data/network/nmcc/station'
    @weather_station = WeatherStation.find_by_name('Fabian Garcia Research Center')
    @start_date = "2013-12-25"
    @end_date = "2014-01-06"
    @page = @update_et.fetch(@weather_station.id_code, @start_date, @end_date)
    # @agent = Mechanize.new
    # @page = @agent.get(@html)
    @array = @update_et.parse(@page)
  end

  let(:rake) { Rake::Application.new }
  let(:task_path) { 'lib/tasks/import' }

  # let (:@weather_station) {  }

  before do
    Rake.application = rake
    Rake.application.rake_require(task_path, [Rails.root.to_s], '')
    Rake::Task.define_task(:environment)
  end

  describe '#initialize' do

    it 'stores a URL' do
      expect(@update_et.url).to eq 'http://weather2.nmsu.edu/wx-stn-data/network/nmcc/station'
    end
  end

  describe '#update' do

    # before(:each) do
    #   Rake::Task['import:current_et'].invoke
    #   @update_et.update(@array, @weather_station)
    # end

    before(:all) do
      Rake::Task['import:current_et'].invoke
      @update_et.update(@array, @weather_station)
    end

    context 'doy' do

      it 'verify doy 365' do
        cet = CurrentEt.find_by(doy: @array[6][:doy])
        expect(cet.doy).to eq @array[6][:doy].to_i
      end

      it 'verify doy 1' do
        cet = CurrentEt.find_by(doy: @array[7][:doy])
        expect(cet.doy).to eq @array[7][:doy].to_i
      end

      it 'verify doy 6' do
        cet = CurrentEt.find_by(doy: @array[12][:doy])
        expect(cet.doy).to eq @array[12][:doy].to_i
      end
    end

    context 'eth' do

      it 'verify eth for day 329' do
        cet = CurrentEt.find_by(doy: 359)
        expect(cet[@weather_station.db_col].to_f).to eq 0.06
      end

      it 'verify eth for day 365' do
        cet = CurrentEt.find_by(doy: 365)
        expect(cet[@weather_station.db_col].to_f).to eq 0.07
      end

      it 'verify eth for day 1' do
        cet = CurrentEt.find_by(doy: 1)
        expect(cet[@weather_station.db_col].to_f).to eq 0.08
      end

      it 'verify eth for day 6' do
        cet = CurrentEt.find_by(doy: 6)
        expect(cet[@weather_station.db_col].to_f).to eq 0.05
      end
    end
  end

  describe '#parse' do

    context 'doy' do

      it 'extracts doy 365' do
        expect(@array[6][:doy]).to eq 365
      end

      it 'extracts doy 1' do
        expect(@array[7][:doy]).to eq 1
      end

      it 'extracts doy 6' do
        expect(@array[12][:doy]).to eq 6
      end
    end

    context 'eth' do

      it 'extracts eth for doy 361' do
        expect(@array[2][:eth].to_f).to eq 0.06
      end

      it 'extracts eth for doy 362' do
        expect(@array[3][:eth].to_f).to eq 0.07
      end

      it 'extracts eth for doy 5' do
        expect(@array[11][:eth].to_f).to eq 0.06
      end

      it 'extracts eth for doy 6' do
        expect(@array[12][:eth].to_f).to eq 0.05
      end
    end
  end

  describe '#pad' do

    before(:all) do
      @update_et.doy = 6
      @update_et.pad(@weather_station)
    end

    it 'nilify eth' do
      185.times do |i|
        doy = 7 + i
        current_et = CurrentEt.find_by_doy(doy)
        expect(current_et[@weather_station.db_col]).to eq nil
      end
    end
  end
end