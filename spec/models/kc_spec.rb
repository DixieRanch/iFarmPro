require 'rails_helper'

describe Kc do
  let(:kc) { Kc.new }

  subject { kc }

  describe "attributes" do
    it { should have_db_column :doy }
    it { should have_db_column :pecan }
  end
end