# == Schema Information
#
# Table name: irrigations
#
#  id         :integer          not null, primary key
#  time       :datetime
#  field_id   :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  company_id :integer
#  farm_id    :integer
#

require 'spec_helper'

describe Irrigation do
  valid_attributes = { time: Time.now }
  let(:company) { build_stubbed(Company) }
  let(:field) { create(:field) }
  let(:irrigation) { field.irrigations.build(valid_attributes) }

  before { Company.current_id = company.id }

  subject { irrigation }

  it { should be_valid }

  it "should have a valid factory" do
    factory = FactoryGirl.build(:irrigation)
    expect(factory).to be_valid
  end

  describe "security" do
    
    it "should have only the current company's data" do
      irrigation.save
      wrong_company = FactoryGirl.create(:company)
      Company.current_id = wrong_company.id
      wrong_data = FactoryGirl.create(:irrigation)
      expect(wrong_data).to be_valid
      Company.current_id = company.id
      expect(Irrigation.all).not_to include(wrong_data)
      expect(Irrigation.all).to include(irrigation)
    end
  end

  describe "attribute" do
    it { should have_db_column :time }
    it { should have_db_column :field_id }
    it { should have_db_column :company_id }
    it { should have_db_column :farm_id}
    it { should have_db_index :field_id }
    it { should have_db_index :company_id }
    it { should have_db_index :farm_id }
  end

  describe "validation" do
    it { should validate_presence_of :time }
  end

  describe "association" do
    it { should accept_nested_attributes_for :meter_readings }
  end

  describe "method" do

    describe "self.next_irrigations" do
      let(:next_irrigations) { Irrigation.next_irrigations }
      before { irrigation.save }
      
      specify { next_irrigations.should be_kind_of(Array) }
      specify { next_irrigations.first.should be_kind_of(Irrigation) }
    end
    
    describe ".next_irrigation_date" do

      let(:next_irrigation) do
        irrigation.next_irrigation_date(Et.all, Kc.all, CurrentEt.all)
      end
      
      it "should return a the next irrigation date" do
        expect(next_irrigation).to be_kind_of(Date)
        expect(next_irrigation).to be > irrigation.time.to_date
      end

      it "should properly handle irrigation interval that crosses new year" do
        irrigation.time = "Dec 30, 2012 12:00"
        irrigation.save
        expect(next_irrigation.year).to be 2013
      end

      context 'after rain' do
        let(:args) { [Et.all, Kc.all, CurrentEt.all] }

        it "has later date" do
          current_date = next_irrigation
          FactoryGirl.create(:rain, date: next_irrigation - 1)
          future_date = irrigation.next_irrigation_date(*args)
          expect(current_date).to be < future_date
        end

        it "same date if available water is at maximum" do
          FactoryGirl.create(:rain, date: irrigation.time.to_date + 2,
                                    amount: 10.0 )
          current_date = irrigation.next_irrigation_date(*args)
          FactoryGirl.create(:rain, date: irrigation.time.to_date + 1,
                                    amount: 10.0 )
          future_date = irrigation.next_irrigation_date(*args)
          expect(current_date).to eq future_date
        end
      end

    end
  end
end