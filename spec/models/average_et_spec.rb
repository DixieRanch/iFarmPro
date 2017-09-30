# == Schema Information
#
# Table name: average_ets
#
#  id                 :integer          not null, primary key
#  doy                :integer
#  eth                :float
#  weather_station_id :integer
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#

require 'rails_helper'

RSpec.describe AverageEt, type: :model do
  
  valid_attributes = { doy: 1,
                       eth: 0.35 }
  let(:wx_station) { build_stubbed(:weather_station) }
  let(:avg_et)     { wx_station.average_ets.new(valid_attributes) }
  
  subject { avg_et }
  
  it {should be_valid}
  
  it "should have a valid factory" do
    factory = build(:average_et)
    expect(factory).to be_valid
  end
  
  describe "validations" do
    it { should validate_presence_of     :doy }
    it { should validate_presence_of     :eth }
    it { should validate_presence_of     :weather_station_id}
    it { should validate_numericality_of(:eth).is_greater_than(0.01).
                                               is_less_than(   0.50) 
    }
    it { should validate_numericality_of(:doy).only_integer.
                                               is_greater_than(  0).
                                               is_less_than(   367) 
    }
  end
end
