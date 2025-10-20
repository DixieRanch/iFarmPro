require 'open-uri'
require 'net/http'
require 'uri'
require 'nokogiri'

module Tasks
  class UpdateEt
    attr_reader :url
    attr_writer :doy

    def initialize(url = nil)
      @url = url
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

    def fetch(weather_station, start_date, end_date)
      # get weather page

      agent = Mechanize.new
      token_uri = URI('https://weather.nmsu.edu/ziamet/station/data/daldkr/')
      token_res = Net::HTTP.get_response(token_uri)

      token_page = Nokogiri::HTML(token_res.body)
      csrf_token = token_page.at('[name="csrfmiddlewaretoken"]')['value']

      post_uri = URI('https://weather.nmsu.edu/ziamet/station/dret/dly/daldkr/')
      params = {
                'csrfmiddlewaretoken' => csrf_token,
                'dtype'               => 'dret',
                'sid'                 => 'daldkr',
                'sdate'               => start_date,
                'edate'               => end_date,
                'output'              => 'tbl',
                'units'               => 'iu'
              }

      # res = Net::HTTP.post_form(post_uri, params)
      http = Net::HTTP.start(post_uri.hostname, post_uri.port, use_ssl: post_uri.scheme == 'https')
      req = Net::HTTP::Post.new(post_uri.request_uri)
      req.set_form_data(params)
      # Referer should point at the page that issued the CSRF token
      req['Referer'] = token_uri.to_s
      # req['User-Agent'] = 'iFarmPro/1.0'
      if token_res.get_fields('set-cookie')
        req['Cookie'] = Array(token_res.get_fields('set-cookie')).map { |c| c.split(';', 2).first }.join('; ')
      end

      res = http.request(req)
      return Mechanize::Page.new(post_uri, res.to_hash, res.body, res.code.to_i, agent)
    end

    def parse(page)
      array = []
      page.search('table')[0].search('tbody').search('tr').each do |row|
        array << { doy: row.search('td')[0].text.to_date.yday,
                   eth: row.search('td')[7].text }
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

    def fetch_parse_update_pad_table
      WeatherStation.all.each do |weather_station|
        page = fetch(weather_station.id_code, start_date, end_date)
        array = parse(page)
        update(array, weather_station)
        pad(weather_station)
      end
    end

    private

    def end_date
      (Time.zone.now - 1.day).strftime('%F')
    end

    def start_date
      (Time.zone.now - 180.days).strftime('%F')
    end
  end
end
