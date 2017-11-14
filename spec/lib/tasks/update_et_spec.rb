require_relative '../../../lib/tasks/update_et'
require 'rails_helper'

describe Tasks::UpdateEt do
  describe '::initialize' do
    it 'sets the URL' do
      update_et = Tasks::UpdateEt.new('http://www.example.com')

      expect(update_et.url).to eq 'http://www.example.com'
    end
  end

  describe '#pad(weather_station)' do
    it 'sets CurrentET for next 185 days to nil' do
      weather_station = create(:weather_station)
      station_symbol = weather_station.db_col.to_sym
      update_et = Tasks::UpdateEt.new(url)
      366.times do |doy|
        CurrentEt.find_or_create_by(doy: doy)
                 .update_attributes(station_symbol => 0.05)
      end
      update_et.doy = 200

      update_et.pad(weather_station)

      expect(CurrentEt.find_by(doy: 200).fabian_garcia).to eq 0.05
      expect(CurrentEt.find_by(doy: 201).fabian_garcia).to be_nil
      expect(CurrentEt.find_by(doy: 366).fabian_garcia).to be_nil
      expect(CurrentEt.find_by(doy: 1).fabian_garcia).to be_nil
      expect(CurrentEt.find_by(doy:  19).fabian_garcia).to be_nil
      expect(CurrentEt.find_by(doy:  20).fabian_garcia).to eq 0.05
    end
  end

  describe '#fetch' do
    it 'returns a Mechanize::Page from weather station url' do
      weather_station_code = create(:weather_station).id_code
      update_et = Tasks::UpdateEt.new(url_prefix)
      stub_request(:get,  url).to_return(form_file)
      stub_request(:post, url).to_return(response_file)

      page = update_et.fetch(weather_station_code, '2017-06-25', '2017-06-30')

      expect(page.class).to eq Mechanize::Page.new.class
    end
  end

  describe '#parse(page)' do
    it 'returns an array of ET hashes' do
      stub_request(:get, url).to_return(response_file)
      page = Mechanize.new.get(url)

      array = Tasks::UpdateEt.new(url).parse(page)

      expect(array[0][:eth]).to eq '0.27'
      expect(array[0][:doy]).to eq 176
      expect(array[5][:eth]).to eq '0.23'
      expect(array[5][:doy]).to eq 181
    end
  end

  describe '#update' do
    it 'saves downloaded eth data to CurrentEt' do
      array = [{ eth: '0.31', doy: 180 }]
      weather_station = build_stubbed(:weather_station)

      expect { Tasks::UpdateEt.new(url).update(array, weather_station) }.to(
        change { CurrentEt.find_by(doy: 180)[weather_station.db_col] }.to(0.31)
      )
    end
  end

  describe '#fetch_parse_update_pad_table' do
    it 'downloads, updates, and pads CurrentEt' do
      weather_station = create(:weather_station)
      station_symbol = weather_station.db_col.to_sym
      update_et = Tasks::UpdateEt.new(url_prefix)
      366.times do |doy|
        CurrentEt.find_or_create_by(doy: doy)
                 .update_attributes(station_symbol => 0.05)
      end
      stub_request(:get,  url).to_return(form_file)
      stub_request(:post, url).to_return(response_file)

      update_et.fetch_parse_update_pad_table

      expect(CurrentEt.find_by(doy: 175)[weather_station.db_col]).to eq 0.05
      expect(CurrentEt.find_by(doy: 176)[weather_station.db_col]).to eq 0.27
      expect(CurrentEt.find_by(doy: 181)[weather_station.db_col]).to eq 0.23
      expect(CurrentEt.find_by(doy: 182)[weather_station.db_col]).to be_nil
      expect(CurrentEt.find_by(doy: 366)[weather_station.db_col]).to be_nil
      expect(CurrentEt.find_by(doy: 1)[weather_station.db_col]).to eq 0.05
    end
  end

  private

  def form_file
    File.new('./spec/fixtures/weather_request_page.html')
  end

  def response_file
    File.new('./spec/fixtures/weather_response_page.html')
  end

  def url
    'http://weather2.nmsu.edu/wx-stn-data/network/nmcc/station/nmcc-da-1/request/gdd/et/data/'
  end

  def url_prefix
    'http://weather2.nmsu.edu/wx-stn-data/network/nmcc/station'
  end
end
