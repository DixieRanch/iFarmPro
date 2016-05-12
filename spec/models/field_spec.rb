# == Schema Information
#
# Table name: fields
#
#  id            :integer          not null, primary key
#  name          :string(255)
#  acreage       :decimal(, )
#  block_id      :integer
#  company_id    :integer
#  created_at    :datetime
#  updated_at    :datetime
#  farm_id       :integer
#  soil_class_id :integer
#

require 'rails_helper'

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
  specify { expect(block).to be_valid }

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
    it { should validate_uniqueness_of(:name).case_insensitive.scoped_to :block_id }
    it { should validate_length_of(:name).is_at_most 8 }
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

    context ".get_yearly_amount_of(nutrient, year)"  do
      
      it "calculates given years applied nutrients" do
        field = create(:field, acreage: 5)
        soil_product = create(:soil_product, n: 16, p: 8, k: 3, s: 4)
        2.times {create(:soil_application, 
                       soil_product: soil_product, quantity: 100, field: field)}
        # Previous years application - should not be included
        create(:soil_application, date: Date.today - 1.year, field: field)
        year = Date.today.year
        # n = 200 gal * 11 lb/gal * 16% N / 5 acres -> 70.4
        expect(field.get_yearly_amount_of(:n, year)).to eq 70.4
        # p = 200 gal * 11 lb/gal * 8% P / 5 acres -> 35.2
        expect(field.get_yearly_amount_of(:p, year)).to eq 35.2
        # k = 200 gal * 11 lb/gal * 3% P / 5 acres -> 13.2
        expect(field.get_yearly_amount_of(:k, year)).to eq 13.2
        # s = 200 gal * 11 lb/gal * 4% S / 5 acres -> 17.6
        expect(field.get_yearly_amount_of(:s, year)).to eq 17.6
      end

      it "handles nil values for nutrients" do
        app = create(:soil_application, soil_product: create(:soil_product, n: nil))
        expect(app.field.get_yearly_amount_of(:n, Time.now.year)).to eq 0
      end
    end
  end
end
