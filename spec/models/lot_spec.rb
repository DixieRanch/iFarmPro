require 'rails_helper'
describe Lot do
  describe 'attributes' do
    it { should have_db_column :name }
    it { should have_db_column :full_weight }
    it { should have_db_column :company_id }
    it { should have_db_column :box_id }
    it { should have_db_column :freezer_location_id }
    it { should have_db_column :block_id }
    it { should have_db_column :field_id }
  end
end
