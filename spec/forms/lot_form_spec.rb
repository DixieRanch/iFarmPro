require 'rails_helper'

describe LotForm do
  describe 'find_box_id_for' do
    it 'returns the box id' do
      set_tenant_company
      box = create(:box)
      lot = LotForm.new(box)
      expect(lot.find_box_id_for(box.name)).to eq box.id
    end
  end
end
