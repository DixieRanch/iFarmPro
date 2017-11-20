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

RSpec.describe AverageEt, :not_a_tenant_model do
  valid_attributes = { doy: 1,
                       eth: 0.35 }

  it 'is valid with valid_attributes' do
    weather_station = build_stubbed :weather_station

    expect(weather_station.average_ets.new(valid_attributes)).to be_valid
  end

  it 'should have a valid factory' do
    expect(build_stubbed(:average_et)).to be_valid
  end

  describe 'validations' do
    it { should validate_presence_of     :doy }
    it { should validate_presence_of     :eth }
    it { should validate_presence_of     :weather_station_id }
    it {
      should validate_numericality_of(:eth).is_greater_than(0.01)
                                           .is_less_than(0.50)
    }
    it {
      should validate_numericality_of(:doy).only_integer
        .is_greater_than(0)
                                           .is_less_than(367)
    }
  end
end
