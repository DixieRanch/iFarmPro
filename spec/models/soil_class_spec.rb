# == Schema Information
#
# Table name: soil_classes
#
#  id         :integer          not null, primary key
#  name       :string
#  aw         :decimal(, )
#  created_at :datetime
#  updated_at :datetime
#

require 'rails_helper'

describe SoilClass do
  valid_attributes = { name: 'Sandy Loam',
                       aw:    8.4 }

  let(:soil_class) { SoilClass.new(valid_attributes) }

  subject { soil_class }

  it { should be_valid }

  it 'should have a valid Factory' do
    expect(FactoryGirl.build(:soil_class)).to be_valid
  end

  describe "attribute" do
    it { should have_db_column :name }
    it { should have_db_column :aw }
  end

  describe "relationship" do
    it { should have_many :fields }
  end

  describe 'validations' do
    it { should validate_presence_of :name }
    it { should validate_presence_of :aw }
    it { should validate_uniqueness_of(:name).case_insensitive }
    it { should validate_numericality_of(:aw) }
  end
end
