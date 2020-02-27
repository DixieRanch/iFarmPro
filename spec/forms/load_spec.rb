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
                          freezer_location: location, box_id: box1.id)
      lot2 = create(:lot, full_weight: 3000,
                          freezer_location: location, box_id: box2.id)
      load1 = Load.new(location)
      weight = (lot1.full_weight - lot1.box.empty_weight) +
               (lot2.full_weight - lot2.box.empty_weight)

      expect(load1.weight).to eq weight
    end
  end

  describe '.lot_total' do
    it 'returns the total count of lots in a Load' do
      set_tenant_company
      location = create(:freezer_location)
      create(:lot, freezer_location: location)
      create(:lot, freezer_location: location)
      lot_count = Lot.all.count
      load1 = Load.new(location)

      expect(load1.lot_count).to eq lot_count
    end
  end

  describe '.move' do
    it 'moves all lots in a load to a new location' do
      set_tenant_company
      original_location = create(:freezer_location)
      new_location = create(:freezer_location)
      lot1 = create(:lot, freezer_location: original_location)
      lot2 = create(:lot, freezer_location: original_location)
      lot3 = create(:lot, freezer_location: original_location)
      load1 = Load.new(original_location)
      load1.move(new_location)
      lot1.reload
      lot2.reload
      lot3.reload

      expect(lot1.freezer_location).to eq new_location
      expect(lot2.freezer_location).to eq new_location
      expect(lot3.freezer_location).to eq new_location
    end
  end

  describe 'persisted?' do
    it 'returns true' do
      set_tenant_company
      location = create(:freezer_location)
      load1 = Load.new(location)

      expect(load1.persisted?).to eq true
    end
  end

  describe '.id' do
    it 'returns the load location id' do
      set_tenant_company
      location = create(:freezer_location)
      load1 = Load.new(location)

      expect(load1.id).to eq location.id
    end
  end
end
