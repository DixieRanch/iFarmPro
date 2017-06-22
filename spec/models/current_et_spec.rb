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

describe CurrentEt do
  let(:current_et) { CurrentEt.new }

  subject { current_et }

  describe 'attributes' do
    it { should have_db_column :doy }
    it { should have_db_column :fabian_garcia }
  end
  
  context "when updating et" do
    
    it "doesn't save et with a 0.0 value" do
      expect(current_et).to be_valid
      current_et.fabian_garcia = 0.0
      expect(current_et.save).to be false
    end
    
  end
end