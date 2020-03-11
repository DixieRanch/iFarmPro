require 'rails_helper'

describe Content, :not_a_tenant_model do
  describe 'attributes' do
    it { should have_db_column :name }
  end

  describe 'factory' do
    it 'is valid' do
      expect(build(:content)).to be_valid
    end
  end

  describe 'validations' do
    it { should validate_presence_of :name }
    it { should validate_uniqueness_of :name }
  end
end
