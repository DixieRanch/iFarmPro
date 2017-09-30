require 'rails_helper'
require 'rake'

# references:
# https://gist.github.com/equivalent/5107645
# http://robots.thoughtbot.com/test-rake-tasks-like-a-boss
# http://carlosplusplus.github.io/blog/2014/02/01/testing-rake-tasks-with-rspec/
# http://pivotallabs.com/how-i-test-rake-tasks/
# http://www.philsergi.com/2009/02/testing-rake-tasks-with-rspec.html

describe 'app lib tasks import.rake', :slow do
  let(:agent) { Mechanize.new }
  let(:weather_url) { 'http://weather2.nmsu.edu/wx-stn-data/network/nmcc/station/nmcc-da-1/request/gdd/et/data/' }
  let(:weather_page) { agent.get(weather_url) }
  let(:rake) { Rake::Application.new }
  let(:task_path) { 'lib/tasks/import' }

  before do
    create(:weather_station)
    Rake.application = rake
    Rake.application.rake_require(task_path, [Rails.root.to_s], '')
    Rake::Task.define_task(:environment)
  end

  context 'get weather url' do
    it 'parses URL' do
      expect(weather_page.uri.to_s).to eq 'https://weather.nmsu.edu/wx-stn-data/network/nmcc/station/nmcc-da-1/request/gdd/et/data/'
    end

    it 'parses heading' do
      expect(weather_page.at('h1').content).to eq 'Request GDD and ET Data for Fabian Garcia SC'
    end
  end

  context 'post weather url' do
    let(:data_page) do
      end_date = Time.now.to_date.strftime('%F')
      start_date = (Time.now - 180.days).strftime('%F')
      weather_page.forms[0]['start_date'] = start_date
      weather_page.forms[0]['end_date'] = end_date
      weather_page.forms[0].submit
    end

    it 'parses URL pre-post' do
      expect(data_page.uri.to_s).to eq 'https://weather.nmsu.edu/wx-stn-data/network/nmcc/station/nmcc-da-1/request/gdd/et/data/'
    end

    it 'parses heading pre post' do
      expect(data_page.at('h1').content).to eq 'Fabian Garcia SC GDD and ET Data'
    end

    it 'parses first header row' do
      row = data_page.search('table')[0].search('thead').search('tr')[0].search('th')
      expect(row[0].text).to eq ''
      expect(row[1].text).to eq 'Temperature'
      expect(row[2].text).to eq 'RH'
      expect(row[3].text).to eq 'Wind Speed'
      expect(row[4].text).to eq 'Solar Radiation'
      # expect(row[5].text).to eq 'Reference ET'
      expect(row[6].text).to eq 'Growing Degree Days'
    end

    it 'parses second header row' do
      row = data_page.search('table')[0].search('thead').search('tr')[1].search('th')
      expect(row[0].text).to eq 'Date'
      expect(row[1].text).to eq 'Max'
      expect(row[2].text).to eq 'Min'
      expect(row[3].text).to eq 'Max'
      expect(row[4].text).to eq 'Min'
      expect(row[5].text).to eq 'Mean'
      expect(row[6].text).to eq 'Total'
      # expect(row[7].text).to eq 'ETh'
      # expect(row[8].text).to eq 'ETo'
      # expect(row[9].text).to eq 'ETr'
      # expect(row[10].text).to eq 'Daily'
      # expect(row[11].text).to eq 'Cumulative'
    end
  end

  it 'should test for the existence of db/et0.csv' do
    expect(File.exist?('db/et0.csv')).to be true
  end

  it 'should test for the existence of db/kcref.csv' do
    expect(File.exist?('db/kcref.csv')).to be true
  end

  it 'should test for the existence of db/current_et.csv' do
    expect(File.exist?('db/current_et.csv')).to be true
  end

  it 'should test for the existence of db/soil_class.csv' do
    expect(File.exist?('db/soil_class.csv')).to be true
  end

  it "has file db/soil_application_unit.csv" do
    expect(File.exist?('db/soil_application_unit.csv')).to be true
  end

  it 'should load ets table with data from db/et0.csv' do
    Rake::Task['import:et'].invoke
    file = 'db/et0.csv'

    WeatherStation.all.each do |_station|
      CSV.foreach(file, headers: true) do |row|
        et = Et.find_by(doy: row['doy'])
        row[0] = row[0].to_i
        row[1] = BigDecimal(row[1]) unless row[1].nil?
        expect(et.attributes).to include row.to_hash
      end
    end
  end

  it 'should load kcs table with data from db/kcref.csv' do
    Rake::Task['import:kc'].invoke
    file = 'db/kcref.csv'

    CSV.foreach(file, headers: true) do |row|
      et = Kc.find_by(doy: row['doy'])
      row[0] = row[0].to_i
      row[1] = BigDecimal(row[1]) unless row[1].nil?
      expect(et.attributes).to include row.to_hash
    end
  end

  it 'should load current_ets table with data from db/current_et.csv' do
    Rake::Task['import:current_et'].invoke
    file = 'db/current_et.csv'

    WeatherStation.all.each do |_station|
      CSV.foreach(file, headers: true) do |row|
        et = CurrentEt.find_by(doy: row['doy'])
        row[0] = row[0].to_i
        row[1] = BigDecimal(row[1]) unless row[1].nil?
        expect(et.attributes).to include row.to_hash
      end
    end
  end

  it 'should load soils_classes table with data from db/soil_class.csv' do
    Rake::Task['import:soil_class'].invoke
    file = 'db/soil_class.csv'

    CSV.foreach(file, headers: true) do |row|
      et = SoilClass.find_by(name: row['name'])
      row[1] = BigDecimal(row[1]) unless row[1].nil?
      expect(et.attributes).to include row.to_hash
    end
  end

  it "loads soil_applicaiton_units table with data from db/soil_application_unit.csv" do
    Rake::Task['import:soil_application_unit'].invoke
    file = 'db/soil_application_unit.csv'

    CSV.foreach(file, headers: true) do |row|
      unit = SoilApplicationUnit.find_by(name: row['name'])
      row[1] = BigDecimal(row[1]) unless row[1].nil?
      expect(unit.attributes).to include row.to_hash
    end
  end

  it "updates CurrentEt with Rake task" do
    et_last_week = CurrentEt.find_by(doy: 5.days.ago.yday)
    et_today = CurrentEt.find_by(doy: Date.today.yday)
    et_next_week = CurrentEt.find_by(doy: Date.today.yday)
    et_last_week.update_attribute(:fabian_garcia, nil)
    et_today.update_attribute(:fabian_garcia, 0.15)
    et_next_week.update_attribute(:fabian_garcia, 0.20)
    Rake::Task['import:update_et'].invoke
    et_last_week.reload
    et_today.reload
    et_next_week.reload
    expect(et_last_week.fabian_garcia).not_to be_nil
    expect(et_today.fabian_garcia).to be_nil
    expect(et_next_week.fabian_garcia).to be_nil
  end
end
