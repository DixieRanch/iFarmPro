require 'rails_helper'

describe SoilApplicationUnit do
  let(:unit) {SoilApplicationUnit.new}

  subject {unit}

  describe "attributes" do
    it { should have_db_column :name }
    it { should have_db_column :density }
  end
end
