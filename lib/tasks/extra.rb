require 'open-uri'

module Tasks
  class Extra

    #"http://weather.nmsu.edu/ws/data/etform/#{weather_station}/"

    def initialize url, weather_station, start_date, end_date
      @url = url
      @weather_station = weather_station
      @start_date = start_date
      @end_date = end_date
    end

    def fetch
      # get weather page
      agent = Mechanize.new
      agent.get("#{@url}/#{@weather_station}")

      # edit start and end date
      agent.page.forms[0]['start_date'] = @start_date
      agent.page.forms[0]['end_date'] = @end_date

      # submit
      agent.page.forms[0].submit
    end

  end
end