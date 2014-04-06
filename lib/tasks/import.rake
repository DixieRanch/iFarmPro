require 'csv'
require 'open-uri'

namespace :import do
  desc "Import ETo data from csv file"
  task et: :environment do

    file = "db/et0.csv"

    CSV.foreach(file, headers: true) do |row|
      et = Et.find_by_doy(row["doy"]) || Et.new
      et.attributes = row.to_hash
      et.save!
    end
  end  

  desc "Import KCref data from csv file"
  task kc: :environment do

    file = "db/kcref.csv"

    CSV.foreach(file, headers: true) do |row|
      kc = Kc.find_by_doy(row["doy"]) || Kc.new
      kc.attributes = row.to_hash
      kc.save!
    end
  end

  desc "Import Current Et data from csv file"
  task current_et: :environment do

    file = "db/current_et.csv"

    CSV.foreach(file, headers: true) do |row|
      current_et = CurrentEt.find_by_doy(row["doy"]) || CurrentEt.new
      current_et.attributes = row.to_hash
      current_et.save!
    end
  end

  desc "Import Current Et data from csv file"
  task soil_class: :environment do

    file = "db/soil_class.csv"

    CSV.foreach(file, headers: true) do |row|
      soil_class = SoilClass.find_by_name(row["name"]) || SoilClass.new
      soil_class.attributes = row.to_hash
      soil_class.save!
    end
  end

  desc "Import Current Et data from csv file"
  task update_et: :environment do

    end_date = Time.now.to_date
    end_date = end_date.strftime("%F")
    start_date = Time.now-180.days
    start_date = start_date.strftime("%F")

    WeatherStation.all.each do |station|
      station_id = station.id_code

      # using the mechanize gem
      # agent = Mechanize.new
      # agent.get("http://weather.nmsu.edu/ws/data/etform/nmcc-da-1/")

      # edit start date
      # agent.page.forms[0]['start_date'] = '2014-04-01'
      # submit
      # agent.page.forms[0].submit

      # get data:
      # date
      # agent.page.search('table').search('th')[-1].text
      # data
      # agent.page.search('table').search('tr')[-1].search('td')[0].text
      # agent.page.search('table').search('tr')[-1].search('td')[1].text
      # agent.page.search('table').search('tr')[-1].search('td')[2].text

      url = "http://weather.nmsu.edu/climate/ws/data/#{station_id}/#{start_date}/0/#{end_date}/0/temperature/0/relative/humidity/0/wind/data/0/precipitation/0/solar/radiation/0/soil/temperature/0/reference/et/1/daily/units/0/qc/0/csv"

      open(url) do |f|
        CSV.parse(f, headers: true) do |row|
          if row[0]
            @doy = row[0].to_date.yday
            current_et = CurrentEt.find_by_doy(@doy)
            current_et[station.db_col] = row[2]
            current_et.save!
          end
        end
      end

      185.times do
        @doy += 1
        current_et = CurrentEt.find_by_doy(@doy)
        current_et[station.db_col] = nil
        current_et.save!
      end
    end
  end

  desc "Add initial weather station"
  task initial_weather_station: :environment do
    attr = { name: "Fabian Garcia Research Center",
             id_code: "nmcc-da-1",
             db_col: "fabian_garcia" }
    WeatherStation.create(attr) if WeatherStation.all.empty?
  end     
end

namespace :db do
  namespace :test do
    task prepare: :environment do
      Rake::Task["db:seed"].invoke
    end
  end
end