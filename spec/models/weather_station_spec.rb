# == Schema Information
#
# Table name: weather_stations
#
#  id         :integer          not null, primary key
#  name       :string
#  id_code    :string
#  db_col     :string
#  created_at :datetime
#  updated_at :datetime
#  website_id :integer
#

require 'rails_helper'

describe WeatherStation, :not_a_tenant_model do
  valid_attributes = { name: 'Fabian Garcia',
                       db_col: 'fabian_garcia',
                       id_code: 'nmcc-da-1' }

  it 'is valid' do
    website = build_stubbed :website

    expect(website.weather_stations.build(valid_attributes)).to be_valid
  end

  it 'should have a valid factory' do
    expect(build_stubbed(:weather_station)).to be_valid
  end

  describe 'validations' do
    it { should validate_presence_of :name }
    it { should validate_presence_of :db_col }
    it { should validate_presence_of :id_code }
    it { should validate_presence_of :website_id }
    it { should validate_uniqueness_of(:name).case_insensitive }
    it { should validate_uniqueness_of(:id_code).scoped_to(:website_id) }
  end

  describe 'associations' do
    it { should have_many :farms }
  end

  describe 'methods to update_daily_et' do
    it 'should build a URL for the data page' do
      correct_url = 'http://weather2.nmsu.edu/wx-stn-data/network/nmcc/station/nmcc-da-1/request/gdd/et/data/'

      url = build_stubbed(:website).weather_stations.build(valid_attributes).url

      expect(url).to eq correct_url
    end

    it 'should fetch a webpage' do
      station = build_stubbed(:weather_station)
      stub_request(:get,  station.url).to_return(form_file)
      stub_request(:post, station.url).to_return(response_file)

      page = station.fetch('2017-06-25', '2017-06-30')

      expect(page.content_type).to match 'text/html'
    end

    it 'should create an array from page data' do
      station = build_stubbed(:weather_station)
      stub_request(:get,  station.url).to_return(form_file)
      stub_request(:post, station.url).to_return(response_file)
      page = station.fetch('2017-06-25', '2017-06-30')

      array = station.parse(page)

      expect(array).to eq [{ date: '2017-06-25'.to_date, eth: 0.27 },
                           { date: '2017-06-26'.to_date, eth: 0.25 },
                           { date: '2017-06-27'.to_date, eth: 0.28 },
                           { date: '2017-06-28'.to_date, eth: 0.3 },
                           { date: '2017-06-29'.to_date, eth: 0.3 },
                           { date: '2017-06-30'.to_date, eth: 0.23 }]
    end

    it 'should update DailyEts from website data' do
      station = create(:weather_station)
      array   = [{ date: '2017-06-25'.to_date, eth: 0.27 },
                 { date: '2017-06-26'.to_date, eth: 0.25 }]

      expect { station.store(array) }.to change { DailyEt.count }.by(2)

      expect(station.daily_ets.find_by(date: '2017-06-25').eth).to eq 0.27
      expect(station.daily_ets.find_by(date: '2017-06-26').eth).to eq 0.25
    end

    it 'should update the last 30 days of Et data' do
      # This test is broken -> Model needs refactoring to test messages sent
      station = create :weather_station
      stub_request(:get,  station.url).to_return(form_file)
      stub_request(:post, station.url).to_return(response_file)

      expect { station.update_daily_et }.to change { DailyEt.count }.by(6)
      expect(station.daily_ets.last.date).to eq '2017-06-30'.to_date
    end
  end

  describe 'methods to update_avg_et' do
    it 'should store average et by day of year in AverageEts' do
      station = create :weather_station
      station.daily_ets.create(date: '2014-01-02', eth: 0.21)
      station.daily_ets.create(date: '2015-01-02', eth: 0.25)
      station.daily_ets.create(date: '2013-01-03', eth: 0.25)
      station.daily_ets.create(date: '2015-01-03', eth: 0.29)

      station.update_average_et

      expect(station.average_ets.find_by(doy: 2).eth).to eq 0.23
      expect(station.average_ets.find_by(doy: 3).eth).to eq 0.27
    end

    it 'should create an hash of average Et by day of year' do
      station = create :weather_station
      station.daily_ets.create(date: '2014-01-02', eth: 0.21)
      station.daily_ets.create(date: '2015-01-02', eth: 0.25)
      station.daily_ets.create(date: '2013-01-03', eth: 0.25)
      station.daily_ets.create(date: '2015-01-03', eth: 0.29)
      correct_hash = { 2 => 0.23, 3 => 0.27 }

      expect(station.doy_average_et_hash).to eq correct_hash
    end
  end

  describe 'load_history' do
    # This test is so slow, that it is commented out until needed.

    # it "should load a weather_staion past et history into DailyEts" do
    #   # 20 years of history, if available, should be loaded into DailyEts
    #   station.save
    #   expect(station.daily_ets.find_by(date: Date.yesterday)).to be_nil
    #   expect(station.daily_ets.find_by(date: "2015-07-01")).to   be_nil
    #   expect(station.daily_ets.find_by(date: "2005-07-01")).to   be_nil
    #   station.load_history
    #   expect(station.daily_ets.find_by(date: Date.yesterday)).to_not be_nil
    #   expect(station.daily_ets.find_by(date: "2015-07-01").eth).to eq 0.29
    #   # expect(station.daily_ets.find_by(date: "2005-07-01").eth).to eq 0.33
    #   too_old = 21.years.ago.to_date
    #   expect(station.daily_ets.find_by(date: too_old)).to be_nil
    # end
  end

  private

  def form_file
    File.new('./spec/fixtures/weather_request_page.html')
  end

  def response_file
    File.new('./spec/fixtures/weather_response_page.html')
  end
end
