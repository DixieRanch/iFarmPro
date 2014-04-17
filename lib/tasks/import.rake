require 'csv'
require 'open-uri'
require 'tasks/extra'

namespace :import do
  desc 'Import ETo data from csv file'
  task et: :environment do

    file = 'db/et0.csv'

    CSV.foreach(file, headers: true) do |row|
      et = Et.find_by_doy(row['doy']) || Et.new
      et.attributes = row.to_hash
      et.save!
    end
  end

  desc 'Import KCref data from csv file'
  task kc: :environment do

    file = 'db/kcref.csv'

    CSV.foreach(file, headers: true) do |row|
      kc = Kc.find_by_doy(row['doy']) || Kc.new
      kc.attributes = row.to_hash
      kc.save!
    end
  end

  desc 'Import Current Et data from csv file'
  task current_et: :environment do

    file = 'db/current_et.csv'

    CSV.foreach(file, headers: true) do |row|
      current_et = CurrentEt.find_by_doy(row['doy']) || CurrentEt.new
      current_et.attributes = row.to_hash
      current_et.save!
    end
  end

  desc 'Import Current Et data from csv file'
  task soil_class: :environment do

    file = 'db/soil_class.csv'

    CSV.foreach(file, headers: true) do |row|
      soil_class = SoilClass.find_by_name(row['name']) || SoilClass.new
      soil_class.attributes = row.to_hash
      soil_class.save!
    end
  end

  task get

  desc 'Import Current Et data from csv file'
  task update_et: :environment do

    end_date = Time.now.to_date
    end_date = end_date.strftime('%F')
    start_date = Time.now-180.days
    start_date = start_date.strftime('%F')

    WeatherStation.all.each do |station|
      station_id = station.id_code

      #page = post_weather_station_url(station_id,start_date,end_date)
      e = Tasks::Extra.new('http://weather.nmsu.edu/ws/data/etform', station_id, start_date, end_date)
      page = e.fetch

      page.search('table')[1].search('tbody').search('tr').each do |row|
        @doy = row.search('th')[0].text.to_date.yday
        current_et = CurrentEt.find_by_doy(@doy)
        current_et[station.db_col] = row.search('td')[6].text
        current_et.save!
      end

      185.times do
        @doy += 1
        current_et = CurrentEt.find_by_doy(@doy)
        current_et[station.db_col] = nil
        current_et.save!
      end
    end
  end

  desc 'Add initial weather station'
  task initial_weather_station: :environment do
    attr = { name: 'Fabian Garcia Research Center',
             id_code: 'nmcc-da-1',
             db_col: 'fabian_garcia' }
    WeatherStation.create(attr) if WeatherStation.all.empty?
  end

  desc 'test task'
  task test_task: :environment do
    puts '-- rake output message for testing --'

    end_date = Time.now.to_date.strftime('%F')
    start_date = (Time.now-180.days).strftime('%F')
    page = post_weather_station_url('nmcc-da-1',start_date,end_date) # station id will come from table
    array = parse_weather_data(page)

    array.each do |arr|
      puts "#{arr[:doy]}, #{arr[:eth]}"
    end
  end

  def post_weather_station_url(weather_station, start_date, end_date)
    # get weather page
    agent = Mechanize.new
    agent.get("http://weather.nmsu.edu/ws/data/etform/#{weather_station}/")

    # edit start and end date
    agent.page.forms[0]['start_date'] = start_date
    agent.page.forms[0]['end_date'] = end_date

    # submit
    agent.page.forms[0].submit
  end

  def parse_weather_data(page)
    array = []
    page.search('table')[1].search('tbody').search('tr').each do |row|
      array << {doy: row.search('th')[0].text.to_date.yday, eth: row.search('td')[7].text}
    end
    array
  end

end

namespace :db do
  namespace :test do
    task prepare: :environment do
      Rake::Task['db:seed'].invoke
    end
  end
end