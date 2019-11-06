require 'rails_helper'

describe Box do
  valid_attributes = { name: '001' }

  it 'is valid' do
    set_tenant_company

    expect(Box.new(valid_attributes)).to be_valid
  end

  it 'has a valid factory' do
    set_tenant_company

    create(:box)
    expect(build_stubbed(:box)).to be_valid
  end

  describe 'attributes' do
    it { should have_db_column :name }
    it { should have_db_column :empty_weight }
    it { should have_db_column :company_id }
  end

  describe 'validations' do
    it { should validate_presence_of :name }
    it { should validate_uniqueness_of(:name).scoped_to :company_id }
    it { should validate_length_of(:name).is_at_most 10 }
    it {
      should validate_numericality_of(:empty_weight).allow_nil
        .is_greater_than(150).is_less_than(300)
    }
    it { should validate_presence_of :company_id }
  end

  describe 'associations' do
    it { should belong_to :company }
    it { should have_many :lots }
  end
end
