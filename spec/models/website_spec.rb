require 'rails_helper'

RSpec.describe Website, type: :model do
  
  valid_attributes = { name: "NMSU" }
  
  let(:site) { Website.new(valid_attributes) }
  
  subject { site }
  
  it {should be_valid}
  
  context "validations" do
    it {should validate_presence_of   :name}
    it {should validate_uniqueness_of(:name).case_insensitive}
    it {should validate_uniqueness_of(:url).scoped_to(:url_suffix).
                                            case_insensitive}
  end
end