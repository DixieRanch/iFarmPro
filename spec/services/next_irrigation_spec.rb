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

  context 'after rain' do
    it 'has later date' do
      irrigation = build_stubbed(:irrigation)
      farm = irrigation.field.block.farm
      pre_rain_irrigation_date = irrigation.next_irrigation_date

      create(:rain, date: pre_rain_irrigation_date - 1, farm: farm)
      post_rain_irrigation_date = irrigation.next_irrigation_date

      expect(post_rain_irrigation_date).to be > pre_rain_irrigation_date
    end

    it 'same date if available water is at maximum' do
      irrigation = build_stubbed :irrigation
      create(:rain, date:   irrigation.time.to_date + 2,
                    amount: 10.0,
                    farm:   irrigation.field.block.farm)
      current_date = irrigation.next_irrigation_date
      create(:rain, date:   irrigation.time.to_date + 1,
                    amount: 10.0,
                    farm:   irrigation.field.block.farm)

      future_date = irrigation.next_irrigation_date

      expect(future_date).to eq current_date
    end
  end
end
