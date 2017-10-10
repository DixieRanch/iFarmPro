# == Schema Information
#
# Table name: ets
#
#  id            :integer          not null, primary key
#  doy           :integer
#  fabian_garcia :decimal(, )
#  created_at    :datetime
#  updated_at    :datetime
#

require 'rails_helper'

describe Et do
  let(:et) { Et.new }

  subject { et }

  describe 'attributes' do
    it { should have_db_column :doy }
    it { should have_db_column :fabian_garcia }
  end
end
