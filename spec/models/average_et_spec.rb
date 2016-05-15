require 'rails_helper'

RSpec.describe AverageEt, type: :model do
  
  valid_attributes = { doy: 1,
                       eth: 0.35 }
  let(:wx_station) { create(:weather_station) }
  let(:avg_et)     { wx_station.average_ets.build(valid_attributes) }
  
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
                                              is_less_than(   0.5) }
  end
end