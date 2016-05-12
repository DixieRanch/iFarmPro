# == Schema Information
#
# Table name: historic_ets
#
#  id                 :integer          not null, primary key
#  doy                :integer
#  eth                :float
#  weather_station_id :integer
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#

require 'rails_helper'

RSpec.describe HistoricEt, type: :model do
  let(:historic_et) { HistoricEt.new }
  
  subject { historic_et }
  
  describe 'attributes' do
    it { is_expected.to have_db_column :doy }
    it { is_expected.to have_db_column :eth }
    it { is_expected.to have_db_column :weather_station_id }
    it { is_expected.to have_db_index :doy }
    it { is_expected.to have_db_index :weather_station_id }
  end
end
