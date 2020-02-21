require 'rails_helper'

describe Load do
  describe 'attributes' do
    it { should respond_to :location }
    it { should respond_to :lots }
  end

  describe 'self.all' do
    it 'returns array of Load objects' do
      set_tenant_company
      create(:freezer_location)
      loads = Load.all
      expect(loads).to be_an_instance_of(Array)
      expect(loads[0]).to be_an_instance_of(Load)
    end
  end

  describe 'self.new' do
    it 'creates a Load object with a correct location' do
      set_tenant_company
      location = create(:freezer_location)
      load1 = Load.new(location)
      expect(load1.location).to eq location
    end
  end

  describe '.weight' do
    it 'returns the total net weight of the Load' do
      set_tenant_company
      location = create(:freezer_location)
      box1 = create(:box, empty_weight: 200)
      box2 = create(:box, empty_weight: 200)
      lot1 = create(:lot, full_weight: 2000,
                          freezer_location_id: location.id, box_id: box1.id)
      lot2 = create(:lot, full_weight: 3000,
                          freezer_location_id: location.id, box_id: box2.id)
      load1 = Load.new(location)
      weight = (lot1.full_weight - lot1.box.empty_weight) +
               (lot2.full_weight - lot2.box.empty_weight)

      expect(load1.weight).to eq weight
    end
  end
end
