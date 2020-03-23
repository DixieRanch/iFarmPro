require 'rails_helper'

describe NullBoxWeight, :not_a_tenant_model do
  describe 'weight' do
    it 'returns default weight' do
      expect(NullBoxWeight.new.weight).to eq 200
    end
  end
end
