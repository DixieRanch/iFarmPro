require 'open-uri'

module Tasks
  class UpdateEt
    attr_reader :url
    attr_writer :doy

    def initialize(url)
      @url = url
    end

    def fetch(weather_station, start_date, end_date)
      # get weather page
      agent = Mechanize.new
      agent.get("#{@url}/#{weather_station}/request/gdd/et/data")

      # edit start and end date
      agent.page.forms[0]['start_date'] = start_date
      agent.page.forms[0]['end_date'] = end_date

      # submit
      agent.page.forms[0].submit
    end

    def parse(page)
      array = []
      page.search('table')[0].search('tbody').search('tr').each do |row|
        array << { doy: row.search('td')[0].text.to_date.yday, eth: row.search('td')[10].text }
      end
      array
    end

    def update(array, weather_station)
      array.each do |row|
        @doy = row[:doy]
        current_et = CurrentEt.find_by(doy: @doy)
        current_et[weather_station.db_col] = row[:eth]
        current_et.save!
      end
    end

    def pad(weather_station)
      185.times do
        if @doy < 366
          @doy += 1
        else
          @doy = 1
        end
        current_et = CurrentEt.find_by(doy: @doy)
        current_et[weather_station.db_col] = nil
        current_et.save!
      end
    end

    def fetch_parse_update_pad_table
      end_date =   (Time.zone.now - 1.day).strftime('%F')
      start_date = (Time.zone.now - 180.days).strftime('%F')
      WeatherStation.all.each do |weather_station|
        page = fetch(weather_station.id_code, start_date, end_date)
        array = parse(page)
        update(array, weather_station)
        pad(weather_station)
      end
    end
  end
end
