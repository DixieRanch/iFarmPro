# == Schema Information
#
# Table name: fields
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  acreage    :decimal(, )
#  block_id   :integer
#  company_id :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  farm_id    :integer
#

require 'spec_helper'

describe Field do

  valid_attributes = { name: "1",
                       acreage: 10.5,
                       soil_class_id: 1 }
  let(:company) { build_stubbed(:company) } 
  let(:block) { build_stubbed(:block) }                      
  let(:field) { block.fields.build(valid_attributes) }

  before do
    Company.current_id = company.id
  end

  subject { field }

  it { should be_valid }
  specify { block.should be_valid }

  it "should have a valid factory" do
    factory = FactoryGirl.build(:field)
    expect(factory).to be_valid
  end

  describe "tenant security" do

    it "should have only the current company's data" do
      wrong_company = FactoryGirl.create(:company)
      Company.current_id = wrong_company.id
      parent = FactoryGirl.create(:block)
      expect(parent).to be_valid
      child = parent.fields.create(valid_attributes)
      expect(child).to be_valid
      Company.current_id = company.id
      field.save
      expect(Field.all).not_to include(child)
      expect(Field.all).to include(field)
    end
  end

  describe "attributes" do
    it { should have_db_column :name }
    it { should have_db_column :acreage }
    it { should have_db_column :block_id }
    it { should have_db_column :company_id }
    it { should have_db_column :farm_id }
    it { should have_db_column :soil_class_id }
  end

  describe "validations" do
    it { should validate_presence_of :name }
    it { should validate_uniqueness_of(:name).scoped_to :block_id }
    it { should ensure_length_of(:name).is_at_most 8 }
    it { should validate_numericality_of :acreage }
    it { should_not validate_presence_of :block_id }
    it { should validate_presence_of :company_id }
    it { should validate_presence_of :soil_class_id }
    it "should allow blank :acreage" do
      field.acreage = ""
      expect(field).to be_valid
    end
  end

  describe "relationships" do
    it { should belong_to :block }
    it { should have_many :irrigations }
    it { should belong_to :soil_class }
  end

  describe "method" do

    context ".name_with_block" do
    
      it "should return correct name_with_block" do
        block = create(:block)
        field = block.fields.build(valid_attributes)
        block_field_name = block.name + "-" + field.name
        expect(field.name_with_block).to eq block_field_name
      end
    end
  end
end