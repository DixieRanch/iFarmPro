# == Schema Information
#
# Table name: companies
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime
#  updated_at :datetime
#

require 'rails_helper'

describe Company, :not_a_tenant_model do
  valid_attributes = { name: 'Some company' }

  it { expect(Company.new(valid_attributes)).to be_valid }

  it 'has a valid factory' do
    expect(build_stubbed(:company)).to be_valid
  end

  describe 'attributes' do
    it { should have_db_column :name }
    it { should respond_to :current_id }

    context 'from associations' do
      it { should have_many :users }
      it { should accept_nested_attributes_for :users }
      it { should have_many :farms }
    end
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_length_of(:name).is_at_most(50) }
  end
end
