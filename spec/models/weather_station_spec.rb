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
                       
  let(:website) { create(:website) }                        
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
  
  context "with UdateEt method" do
    xit "should add recent eth" do
      station.save
      expect(station.daily_ets.find_by date: Date.yesterday).to be_nil
      station.update_et
      expect(station.daily_ets.find_by date: Date.yesterday).not_to be_nil
    end
    
  end
end
