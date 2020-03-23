require 'rails_helper'

describe NextIrrigation do
  it 'should return the next irrigation date' do
    irrigation = build_stubbed :irrigation
    field = irrigation.field
    last_irrigation = irrigation.time.to_date
    expect(NextIrrigation.call(irrigation, field)).to be_kind_of(Date)
    expect(NextIrrigation.call(irrigation, field)).to be > last_irrigation
  end

  it 'should properly handle irrigation interval that crosses new year' do
    irrigation = build_stubbed :irrigation, time: 'Dec 30, 2012 12:00'

    expect(NextIrrigation.call(irrigation, irrigation.field).year).to be 2013
  end

  context 'after rain' do
    it 'has later date' do
      irrigation = build_stubbed(:irrigation)
      farm = irrigation.field.block.farm
      pre_rain_irrigation_date =
        NextIrrigation.call(irrigation, irrigation.field)

      create(:rain, date: pre_rain_irrigation_date - 1, farm: farm)
      post_rain_irrigation_date =
        NextIrrigation.call(irrigation, irrigation.field)

      expect(post_rain_irrigation_date).to be > pre_rain_irrigation_date
    end

    it 'same date if available water is at maximum' do
      irrigation = build_stubbed :irrigation
      create(:rain, date:   irrigation.time.to_date + 2,
                    amount: 10.0,
                    farm:   irrigation.field.block.farm)
      current_date = NextIrrigation.call(irrigation, irrigation.field)
      create(:rain, date:   irrigation.time.to_date + 1,
                    amount: 10.0,
                    farm:   irrigation.field.block.farm)

      future_date = NextIrrigation.call(irrigation, irrigation.field)

      expect(future_date).to eq current_date
    end
  end
end
