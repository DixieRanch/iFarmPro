# == Schema Information
#
# Table name: soil_products
#
#  id         :integer          not null, primary key
#  company_id :integer
#  name       :string
#  n          :integer
#  p          :integer
#  k          :integer
#  s          :integer
#  created_at :datetime
#  updated_at :datetime
#

require 'rails_helper'

describe SoilProduct do
  valid_attributes = { name: 'UAN' }

  it 'is valid with valid_attributes' do
    set_tenant_company

    expect(SoilProduct.new(valid_attributes)).to be_valid
  end

  it 'has a valid factory' do
    set_tenant_company

    expect(build_stubbed(:soil_product)).to be_valid
  end

  describe 'attribute' do
    it { should have_db_column :name }
    it { should have_db_column :company_id }
    it { should have_db_column :n }
    it { should have_db_column :p }
    it { should have_db_column :k }
    it { should have_db_column :s }

    context 'validation' do
      it { should validate_presence_of :name }
      it { should validate_uniqueness_of(:name).scoped_to(:company_id) }
      it { should validate_numericality_of(:n).only_integer }
      it { should validate_numericality_of(:p).only_integer }
      it { should validate_numericality_of(:k).only_integer }
      it { should validate_numericality_of(:s).only_integer }
      it { should validate_presence_of :company_id }
    end
  end
end
