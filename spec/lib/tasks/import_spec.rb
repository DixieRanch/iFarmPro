require 'spec_helper'
require 'rake'

# references:
# https://gist.github.com/equivalent/5107645
# http://robots.thoughtbot.com/test-rake-tasks-like-a-boss
# http://carlosplusplus.github.io/blog/2014/02/01/testing-rake-tasks-with-rspec/
# http://pivotallabs.com/how-i-test-rake-tasks/
# http://www.philsergi.com/2009/02/testing-rake-tasks-with-rspec.html

describe 'app lib tasks import.rake' do

  let(:rake) { Rake::Application.new }
  let(:task_path) { 'lib/tasks/import' }
  let(:agent) { Mechanize.new }
  let(:weather_url) { 'http://weather.nmsu.edu/ws/data/etform/nmcc-da-1' }

  before do
    Rake.application = rake
    Rake.application.rake_require(task_path, [Rails.root.to_s], '')
    Rake::Task.define_task(:environment)
  end

  it 'validates weather URL' do
     agent.get(weather_url)
     expect(agent.page.uri.to_s).to eq 'http://weather.nmsu.edu/ws/data/etform/nmcc-da-1/'
  end

  it 'validates some html structure from post data from weather url' do
    pending 'TODO'
  end

  it 'should test for the existence of db/et0.csv' do
    File.exist?('db/et0.csv').should == true
  end

  it 'should test for the existence of db/kcref.csv' do
    File.exist?('db/kcref.csv').should == true
  end

  it 'should test for the existence of db/current_et.csv' do
    File.exist?('db/current_et.csv').should == true
  end

  it 'should test for the existence of db/soil_class.csv' do
    File.exist?('db/soil_class.csv').should == true
  end

  it 'should load ets table with data from db/et0.csv' do
    Rake::Task['import:et'].invoke
    file = 'db/et0.csv'

    WeatherStation.all.each do |station|
      CSV.foreach(file, headers: true) do |row|
        et = Et.find_by_doy(row['doy'], select: "doy, #{station.db_col}")
        row[0] = row[0].to_i
        row[1] = BigDecimal(row[1]) unless row[1].nil?
        expect(et.attributes).to eq row.to_hash
      end
    end

  end

  it 'should load kcs table with data from db/kcref.csv' do
    Rake::Task['import:kc'].invoke
    file = 'db/kcref.csv'

    CSV.foreach(file, headers: true) do |row|
      et = Kc.find_by_doy(row['doy'], select: 'doy, pecan')
      row[0] = row[0].to_i
      row[1] = BigDecimal(row[1]) unless row[1].nil?
      expect(et.attributes).to eq row.to_hash
    end

  end

  it 'should load current_ets table with data from db/current_et.csv' do
    Rake::Task['import:current_et'].invoke
    file = 'db/current_et.csv'

    WeatherStation.all.each do |station|
      CSV.foreach(file, headers: true) do |row|
        et = CurrentEt.find_by_doy(row['doy'], select: "doy, #{station.db_col}")
        row[0] = row[0].to_i
        row[1] = BigDecimal(row[1]) unless row[1].nil?
        expect(et.attributes).to eq row.to_hash
      end
    end

  end

  it 'should load soils_classes table with data from db/soil_class.csv' do
    Rake::Task['import:soil_class'].invoke
    file = 'db/soil_class.csv'

    CSV.foreach(file, headers: true) do |row|
      et = SoilClass.find_by_name(row['name'], select: 'name, aw')
      row[1] = BigDecimal(row[1]) unless row[1].nil?
      expect(et.attributes).to eq row.to_hash
    end

  end

end


