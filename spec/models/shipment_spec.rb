require 'rails_helper'

describe Shipment do
  describe 'attributes' do
    it { should have_db_column :name }
    it { should have_db_column :date }
    it { should have_db_column :destination }
    it { should have_db_column :farm_id }
    it { should have_db_column :company_id }
  end
end
