require_relative '../../../lib/tasks/update_et'
require 'rake'

describe Tasks::UpdateEt do

  let(:update_et) { Tasks::UpdateEt.new 'http://weather.nmsu.edu/ws/data/etform' }
  let(:html) { "file://#{Rails.root.join('spec', 'fixtures')}/nmcc-da-1.html" }
  let (:agent) { Mechanize.new }
  let (:page) { agent.get(html) }
  let (:array) { update_et.parse(page) }

  let(:rake) { Rake::Application.new }
  let(:task_path) { 'lib/tasks/import' }

  before do
    Rake.application = rake
    Rake.application.rake_require(task_path, [Rails.root.to_s], '')
    Rake::Task.define_task(:environment)
  end

  describe '#initialize' do

    it 'stores a URL' do
      expect(update_et.url).to eq 'http://weather.nmsu.edu/ws/data/etform'
    end

  end

  describe '#update' do

    let (:weather_station) { WeatherStation.find_by_name('Fabian Garcia Research Center') }

    before(:each) do
      #Rake::Task['import:current_et'].invoke
      update_et.update(array, weather_station)
      #puts array
    end

    context 'doy' do

      it 'verify doy 359' do
        et = Et.find_by_doy(array[0][:doy], select: "doy, #{weather_station.db_col}")
        expect(et.doy).to eq array[0][:doy].to_i
      end

      it 'verify doy 360' do
        et = Et.find_by_doy(array[1][:doy], select: "doy, #{weather_station.db_col}")
        expect(et.doy).to eq array[1][:doy].to_i
      end

    end

    context 'eth' do

      it 'verify eth for day 359' do
        pending 'need to get working'
        #et = Et.find_by_doy(array[0][:doy], select: "doy, #{weather_station.db_col}")
        #et = Et.find_by_doy(array[0][:doy])
        # puts array[0][:doy]
        # puts et.attributes
        # value = BigDecimal(array[0][:eth])
        # expect(et.fabian_garcia).to eq value
      end

    end

  end

  describe '#parse' do

    context 'doy' do

      it 'extracts doy 359' do
        expect(array[0][:doy]).to eq 359
      end

      it 'extracts doy 360' do
        expect(array[1][:doy]).to eq 360
      end

      it 'extracts doy 361' do
        expect(array[2][:doy]).to eq 361
      end

      it 'extracts doy 362' do
        expect(array[3][:doy]).to eq 362
      end

      it 'extracts doy 363' do
        expect(array[4][:doy]).to eq 363
      end

      it 'extracts doy 364' do
        expect(array[5][:doy]).to eq 364
      end

      it 'extracts doy 365' do
        expect(array[6][:doy]).to eq 365
      end

      it 'extracts doy 1' do
        expect(array[7][:doy]).to eq 1
      end

      it 'extracts doy 2' do
        expect(array[8][:doy]).to eq 2
      end

      it 'extracts doy 3' do
        expect(array[9][:doy]).to eq 3
      end

      it 'extracts doy 4' do
        expect(array[10][:doy]).to eq 4
      end

      it 'extracts doy 5' do
        expect(array[11][:doy]).to eq 5
      end

      it 'extracts doy 6' do
        expect(array[12][:doy]).to eq 6
      end

    end

    context 'eth' do

      it 'extracts eth for doy 359' do
        expect(array[0][:eth].strip).to eq ''
      end

      it 'extracts eth for doy 360' do
        expect(array[1][:eth].strip).to eq ''
      end

      it 'extracts eth for doy 361' do
        expect(array[2][:eth].strip).to eq ''
      end

      it 'extracts eth for doy 362' do
        expect(array[3][:eth].to_f).to eq 0.0
      end

      it 'extracts eth for doy 363' do
        expect(array[4][:eth].to_f).to eq 0.05
      end

      it 'extracts eth for doy 364' do
        expect(array[5][:eth].to_f).to eq 0.07
      end

      it 'extracts eth for doy 365' do
        expect(array[6][:eth].to_f).to eq 0.07
      end

      it 'extracts eth for doy 1' do
        expect(array[7][:eth].to_f).to eq 0.08
      end

      it 'extracts eth for doy 2' do
        expect(array[8][:eth].to_f).to eq 0.07
      end

      it 'extracts eth for doy 3' do
        expect(array[9][:eth].to_f).to eq 0.08
      end

      it 'extracts eth for doy 4' do
        expect(array[10][:eth].to_f).to eq 0.08
      end

      it 'extracts eth for doy 5' do
        expect(array[11][:eth].to_f).to eq 0.06
      end

      it 'extracts eth for doy 6' do
        expect(array[12][:eth].strip).to eq ''
      end

    end

  end

end