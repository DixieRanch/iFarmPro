require 'csv'
require 'tasks/update_et'

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

  desc 'Import Soil Application Unit data from csv file'
  task soil_application_unit: :environment do
    
    file = 'db/soil_application_unit.csv'

    CSV.foreach(file, headers: true) do |row|
      unit = SoilApplicationUnit.find_by(name: row['name']) || SoilApplicationUnit.new
      unit.attributes = row.to_hash
      unit.save!
    end
  end

  desc 'Import Current Et data from csv file'
  task update_et: :environment do
    update_et = Tasks::UpdateEt.new('http://weather2.nmsu.edu/wx-stn-data/network/nmcc/station')
    update_et.fetch_parse_update_pad_table
  end

  desc 'Add initial weather station'
  task initial_weather_station: :environment do
    attr = {name: 'Fabian Garcia Research Center',
            id_code: 'nmcc-da-1',
            db_col: 'fabian_garcia'}
    WeatherStation.create(attr) if WeatherStation.all.empty?
  end

end

namespace :db do
  namespace :test do
    task prepare: :environment do
      Rake::Task['db:seed'].invoke
    end
  end
end