require 'rails_helper'

describe NextIrrigation, :not_a_tenant_model do
  it 'should return the next irrigation date' do
    irrigation = build_stubbed :irrigation

    expect(NextIrrigation.new(irrigation, irrigation.field).next_date).to be_kind_of(Date)
    expect(NextIrrigation.new(irrigation, irrigation.field).next_date).to be > irrigation.time.to_date
  end

  it 'should properly handle irrigation interval that crosses new year' do
    irrigation = build_stubbed :irrigation, time: 'Dec 30, 2012 12:00'

    expect(NextIrrigation.new(irrigation, irrigation.field).next_date.year).to be 2013
  end
end
