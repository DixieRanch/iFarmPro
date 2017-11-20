# == Schema Information
#
# Table name: kcs
#
#  id         :integer          not null, primary key
#  doy        :integer
#  pecan      :decimal(, )
#  created_at :datetime
#  updated_at :datetime
#

require 'rails_helper'

describe Kc, :not_a_tenant_model do
  describe 'attributes' do
    it { should have_db_column :doy }
    it { should have_db_column :pecan }
  end
end
