require 'rails_helper'

describe ContentClass, :not_a_tenant_model do
  describe 'attributes' do
    it { should have_db_column :grade }
  end

  describe 'relationships' do
    it { should have_many :lots }
  end

  describe 'validations' do
    it { should validate_presence_of :grade }
  end
end
