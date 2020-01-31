# == Schema Information
#
# Table name: soil_application_units
#
#  id         :integer          not null, primary key
#  name       :string
#  density    :float
#  created_at :datetime
#  updated_at :datetime
#

require 'rails_helper'

describe SoilApplicationUnit, :not_a_tenant_model do
  valid_attributes = { name:   'Gal',
                       density: 11 }

  it { expect(SoilApplicationUnit.new(valid_attributes)).to be_valid }

  it 'has a valid Factory' do
    create(:soil_application_unit)

    expect(build_stubbed(:soil_application_unit)).to be_valid
  end

  describe 'attributes' do
    it { should have_db_column :name }
    it { should have_db_column :density }
  end

  describe 'validations' do
    it { should validate_presence_of :name }
    it { should validate_presence_of :density }
    it { should validate_uniqueness_of(:name).case_insensitive }
    it { should validate_numericality_of :density }
  end
end
