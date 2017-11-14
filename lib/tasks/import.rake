require 'csv'
require 'tasks/update_et'

namespace :import do
  desc 'Import Current Et data from csv file'
  task update_et: :environment do
    update_et = Tasks::UpdateEt.new('http://weather2.nmsu.edu/wx-stn-data/network/nmcc/station')
    update_et.fetch_parse_update_pad_table
  end

  desc 'Add initial weather station'
  task initial_weather_station: :environment do
    attr = { name:       'NMSU',
             url: 'http://weather2.nmsu.edu/wx-stn-data/network/nmcc/station/',
             url_suffix: '/request/gdd/et/data/' }

    wx_attr = { name:    'Fabian Garcia Research Center',
                id_code: 'nmcc-da-1',
                db_col:  'fabian_garcia' }
    website = if Website.all.empty?
                Website.create(attr)
              else
                Website.find_by(name: attr[:name])
              end
    website.weather_stations.create(wx_attr) if WeatherStation.all.empty?
  end
end

namespace :db do
  namespace :test do
    task prepare: :environment do
      Rake::Task['import:et'].invoke
      Rake::Task['import:kc'].invoke
      Rake::Task['import:current_et'].invoke
    end
  end
end
