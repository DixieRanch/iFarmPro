require 'rails_helper'

describe NullIrrigation, :not_a_tenant_model do
  describe '#next_irrigation_date' do
    it 'returns July 1st of previous year' do
      next_irrigation_date = NullIrrigation.new.next_irrigation_date

      expect(next_irrigation_date.to_date).to eq(
        Date.new((Time.zone.now.year - 1), 7, 1)
      )
    end
  end

  describe '#field' do
    it 'returns the specified Field object' do
      set_tenant_company
      field = create :field
      irrigation = NullIrrigation.new(field)

      expect(irrigation.field).to eq field
    end
  end

  describe '#time' do
    it 'returns July 1st of previous year' do
      time = NullIrrigation.new.time

      expect(time.to_date).to eq Date.new((Time.zone.now.year - 1), 7, 1)
    end
  end
end
