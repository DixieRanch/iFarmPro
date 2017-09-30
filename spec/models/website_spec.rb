# == Schema Information
#
# Table name: websites
#
#  id         :integer          not null, primary key
#  name       :string
#  url        :string
#  url_suffix :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

RSpec.describe Website, type: :model do
  
  valid_attributes = { 
    name: "NMSU",
    url:  "http://weather2.nmsu.edu/wx-stn-data/network/nmcc/station/"}
  
  let(:site) { Website.new(valid_attributes) }
  
  subject { site }
  
  it {should be_valid}
  
  it "should have a valid factory" do
    site = build(:website)
    expect(site).to be_valid
  end
  
  
  context "validations" do
    it {should validate_presence_of   :name}
    it {should validate_presence_of   :url}
    it {should validate_uniqueness_of(:name).case_insensitive}
    it {
      should validate_uniqueness_of(:url).scoped_to(:url_suffix)
                                            .case_insensitive
    }
  end
end
