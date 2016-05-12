# == Schema Information
#
# Table name: soil_application_units
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  density    :float
#  created_at :datetime
#  updated_at :datetime
#

require 'rails_helper'

describe SoilApplicationUnit do
  let(:unit) {SoilApplicationUnit.new}

  subject {unit}

  describe "attributes" do
    it { should have_db_column :name }
    it { should have_db_column :density }
  end
end
