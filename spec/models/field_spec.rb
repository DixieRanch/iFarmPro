# == Schema Information
#
# Table name: fields
#
#  id            :integer          not null, primary key
#  name          :string
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
  valid_attributes = { name: '1', soil_class_id: 1 }

  it 'is valid' do
    set_tenant_company

    expect(build_stubbed(:block).fields.new(valid_attributes)).to be_valid
  end

  it 'has a valid factory' do
    set_tenant_company

    expect(build_stubbed(:field)).to be_valid
  end

  describe 'tenant security' do
    it "should have only the current company's data" do
      set_tenant_company
      other_companys_data = create :field

      set_tenant_company
      this_companys_data = create :field

      expect(Field.all).to include this_companys_data
      expect(Field.all).not_to include other_companys_data
    end
  end

  describe 'attributes' do
    it { should have_db_column :name }
    it { should have_db_column :acreage }
    it { should have_db_column :block_id }
    it { should have_db_column :company_id }
    it { should have_db_column :farm_id }
    it { should have_db_column :soil_class_id }
  end

  describe 'validations' do
    it { should validate_presence_of :name }
    it { should validate_length_of(:name).is_at_most 8 }
    it { should validate_numericality_of :acreage }
    it { should_not validate_presence_of :block_id }
    it { should validate_presence_of :company_id }
    it { should validate_presence_of :soil_class_id }
    it 'has a unique name scoped to block' do
      field = build_stubbed(:block).fields.new valid_attributes

      expect(field).to validate_uniqueness_of(:name).case_insensitive
                                                    .scoped_to :block_id
    end
  end

  describe 'relationships' do
    it { should belong_to :block }
    it { should have_many :irrigations }
    it { should belong_to :soil_class }
  end

  describe '#name_with_block' do
    it 'returns correct name_with_block' do
      set_tenant_company
      block = create(:block)
      field = block.fields.new valid_attributes

      block_field_name = block.name + '-' + field.name

      expect(field.name_with_block).to eq block_field_name
    end
  end

  describe '#get_yearly_amount_of(nutrient, year)' do
    it 'calculates given years applied nutrients' do
      set_tenant_company
      field = create(:field, acreage: 5)
      2.times do
        create(:soil_application, quantity: 100, field: field,
                                  date: Time.zone.now)
      end
      # Previous years application - should not be included
      create(:soil_application, quantity: 100, field: field,
                                date: 1.year.ago)

      expect(field.get_yearly_amount_of(:n, Time.zone.today.year)).to eq 70.4
    end

    context 'when nutrient value is nil' do
      it 'returns 0' do
        set_tenant_company
        app = create(:soil_application,
                     soil_product: create(:soil_product, n: nil))

        expect(app.field.get_yearly_amount_of(:n, Time.zone.now.year)).to eq 0
      end
    end
  end
end
