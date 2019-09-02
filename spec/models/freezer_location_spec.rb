require 'rails_helper'

describe FreezerLocation do
  describe 'attributes' do
    it { should have_db_column :name }
    it { should have_db_column :farm_id }
    it { should have_db_column :company_id }
  end

  describe 'validations' do
    it { should validate_presence_of :name }
    it { should validate_presence_of :farm_id }
    it { should validate_presence_of :company_id }
  end
end
