# == Schema Information
#
# Table name: current_ets
#
#  id            :integer          not null, primary key
#  doy           :integer
#  fabian_garcia :decimal(, )
#  created_at    :datetime
#  updated_at    :datetime
#

require 'rails_helper'

describe CurrentEt, :not_a_tenant_model do
  valid_attributes = { fabian_garcia: 0.23 }

  it { expect(CurrentEt.new(valid_attributes)).to be_valid }

  describe 'attributes' do
    it { should have_db_column :doy }
    it { should have_db_column :fabian_garcia }
  end

  describe 'validates' do
    it { should validate_numericality_of(:fabian_garcia).allow_nil }
  end

  it 'is invalid with 0.0 value for et' do
    expect(CurrentEt.new(fabian_garcia: 0.0)).to be_invalid
  end
end
