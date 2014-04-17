require 'spec_helper'

describe CurrentEt do
  let(:current_et) { CurrentEt.new }

  subject { current_et }

  describe 'attributes' do
    it { should have_db_column :doy }
    it { should have_db_column :fabian_garcia }
  end
end