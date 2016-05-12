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
  let(:station) { WeatherStation.new(valid_attributes) }

  subject { station }

  it { should be_valid }

  it "should have a valid factory" do
    station = build(:weather_station)
    expect(station).to be_valid
  end

  describe "attribute" do
    it { should have_db_column :name }
    it { should have_db_column :db_col }
    it { should have_db_column :id_code }
  end

  describe "validation" do
    it { should validate_presence_of :name }
    it { should validate_presence_of :db_col }
    it { should validate_presence_of :id_code }
  end

  describe "association" do
    it { should have_many :farms }
  end
end
