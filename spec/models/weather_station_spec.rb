# == Schema Information
#
# Table name: weather_stations
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  id_code    :string(255)
#  db_col     :string(255)
#  created_at :datetime
#  updated_at :datetime
#

require 'rails_helper'

describe WeatherStation do

  valid_attributes = { name: "Fabian Garcia",
                       db_col: "fabian_garcia",
                       id_code: "nmcc-da-1" }
                       
  website_attributes = { 
    name:       "NMSU",
    url:        "http://weather2.nmsu.edu/wx-stn-data/network/nmcc/station/",
    url_suffix: "/request/gdd/et/data/" }
                       
  let(:website) { Website.create(website_attributes) }                        
  let(:station) { website.weather_stations.build(valid_attributes) }

  subject { station }

  it { should be_valid }

  it "should have a valid factory" do
    station = build(:weather_station)
    expect(station).to be_valid
  end

  describe "unvalidated attributes" do

  end

  describe "validations" do
    it { should validate_presence_of :name }
    it { should validate_presence_of :db_col }
    it { should validate_presence_of :id_code }
    it { should validate_presence_of :website_id }
  end

  describe "associations" do
    it { should have_many :farms }
  end
  
  describe "methods to update_daily_et" do
    # NMSU Fabian Garcia data for 2015: 07-01: 0.29; 07-02: 0.31
    let(:start_date) {"2015-07-01"}
    let(:end_date)   {"2015-07-02"}
    let(:page)       {station.fetch(start_date, end_date)}
    let(:array)      {station.parse(page)}
    
    it "should build a URL for the data page" do
      url = station.url
      correct_url = "http://weather2.nmsu.edu/wx-stn-data/network/nmcc/station/nmcc-da-1/request/gdd/et/data/"
      expect(url).to eq correct_url
    end
    
    
    it "should fetch a webpage", slow: true do
      expect(page.content_type).to match "text/html"
    end
    
    it "should create an array from page data", slow: true do
      expect(array).to eq [{date: "2015-07-01".to_date, eth: 0.29},
                           {date: "2015-07-02".to_date, eth: 0.31}]
    end
    
    it "should update DailyEts from website data", slow: true do
      station.save
      expect{station.store(array)}.to change{DailyEt.count}.by(2)
      expect(station.daily_ets.find_by(date: "2015-07-01").eth).to eq 0.29
      expect(station.daily_ets.find_by(date: "2015-07-02").eth).to eq 0.31
    end
    
    it "should update the last 30 days of Et data", slow: true do
      station.save
      expect{station.update_daily_et}.to change{DailyEt.count}.by(30)
      expect(station.daily_ets.last.date).to eq Date.yesterday
    end
  end
  
  describe "methods to update_avg_et" do
    
    before :each do
      # create daily_ets with doy: 2 avg of 0.23, & doy: 3 avg of 0.27
      station.save
      station.daily_ets.create(date: "2014-01-02", eth: 0.21)
      station.daily_ets.create(date: "2015-01-02", eth: 0.25)
      station.daily_ets.create(date: "2013-01-03", eth: 0.25)
      station.daily_ets.create(date: "2015-01-03", eth: 0.29)
    end
    
    it "should store average et by day of year in AverageEts" do
      station.update_average_et
      expect(station.average_ets.find_by(doy: 2).eth).to eq 0.23
      expect(station.average_ets.find_by(doy: 3).eth).to eq 0.27
    end
    
    it "should create an hash of average Et by day of year" do
      correct_hash = { 2 => 0.23, 3 => 0.27 }
      expect(station.doy_average_et_hash).to eq correct_hash
    end
  end
  
  describe "load_history", slow: true do
    it "should load a weather_staion past et history into DailyEts" do
      # 20 years of history, if available, should be loaded into DailyEts
      station.save
      expect(station.daily_ets.find_by(date: Date.yesterday)).to be_nil
      expect(station.daily_ets.find_by(date: "2015-07-01")).to   be_nil
      expect(station.daily_ets.find_by(date: "2005-07-01")).to   be_nil
      station.load_history
      expect(station.daily_ets.find_by(date: Date.yesterday)).to_not be_nil
      expect(station.daily_ets.find_by(date: "2015-07-01").eth).to eq 0.29
      expect(station.daily_ets.find_by(date: "2005-07-01").eth).to eq 0.33
      too_old = 21.years.ago.to_date
      expect(station.daily_ets.find_by(date: too_old)).to be_nil
    end
  end
end