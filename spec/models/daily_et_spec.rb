require 'rails_helper'

RSpec.describe DailyEt, type: :model do
  let(:daily_et) { DailyEt.new }
  
  subject { daily_et }
  
  describe  'attributes' do
    it { is_expected.to have_db_column :date }
    it { is_expected.to have_db_column :eth }
    it { is_expected.to have_db_column :weather_station_id }
    it { is_expected.to have_db_index :date }
    it { is_expected.to have_db_index :weather_station_id }
  end
end
