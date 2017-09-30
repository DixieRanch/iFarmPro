# == Schema Information
#
# Table name: daily_ets
#
#  id                 :integer          not null, primary key
#  date               :date
#  eth                :float
#  weather_station_id :integer
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#

require 'rails_helper'

RSpec.describe DailyEt, type: :model do
  
  valid_attributes = { date: '5/7/2013',
                       eth:   0.27 }
  
  let(:wx_station) { create(:weather_station) }
  let(:daily_et) { wx_station.daily_ets.build(valid_attributes) }
  
  subject { daily_et }
  
  it { should be_valid }
  
  it "should have a valid factory" do
    factory = FactoryGirl.build(:daily_et)
    expect(factory).to be_valid
  end

  describe  'attributes' do
    it { is_expected.to have_db_column :date }
    it { is_expected.to have_db_column :eth }
    it { is_expected.to have_db_column :weather_station_id }
    it { is_expected.to have_db_index :date }
    it { is_expected.to have_db_index :weather_station_id }
  end
  
  describe 'validations' do
    it { should validate_presence_of :date }
    it { should validate_presence_of :weather_station_id }
    it { should validate_presence_of :eth }
    it { should validate_numericality_of(:eth).is_greater_than(0.01)
                                               .is_less_than(   0.5)
    }
  end
end