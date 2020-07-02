require 'rails_helper'
describe Lot do
  valid_attributes = { name: '2018-001',
                       full_weight: 2000,
                       box_id: 1,
                       freezer_location_id: 1,
                       block_id: 1 }

  it 'is valid' do
    set_tenant_company

    expect(Lot.new(valid_attributes)).to be_valid
  end

  it 'has a valid factory' do
    set_tenant_company

    create(:lot)
    expect(build_stubbed(:lot)).to be_valid
  end

  describe 'attributes' do
    it { should have_db_column :name }
    it { should have_db_column :full_weight }
    it { should have_db_column :company_id }
    it { should have_db_column :box_id }
    it { should have_db_column :freezer_location_id }
    it { should have_db_column :block_id }
    it { should have_db_column :field_id }
    it { should have_db_column :content_id }
    it { should have_db_column :shipment_id }
  end

  describe 'validations' do
    it { should validate_presence_of :name }
    it { should validate_length_of(:name).is_at_most 8 }
    it { should validate_uniqueness_of(:name).scoped_to :company_id }
    it { should validate_numericality_of(:full_weight).is_greater_than(150) }
    it { should validate_presence_of :company_id }
    it { should validate_presence_of :box_id }
    it { should validate_presence_of :block_id }

    it 'validates that lot with location and shipment is invalid' do
      set_tenant_company
      location = create(:freezer_location)
      lot = create(:lot, freezer_location_id: location.id)
      lot.shipment_id = 1

      expect(lot).to_not be_valid
    end

    it 'validates that lot with a freexer location is valid' do
      set_tenant_company
      location = create(:freezer_location)
      lot = create(:lot, freezer_location_id: location.id)

      expect(lot).to be_valid
    end

    it 'validates that lot with a shipment is valid' do
      set_tenant_company
      lot = create(:lot, shipment_id: 1, freezer_location_id: nil)

      expect(lot).to be_valid
    end

    it 'validates that lot without location or shipment is invalid' do
      set_tenant_company
      lot = create(:lot)
      lot.freezer_location_id = nil
      lot.shipment_id = nil

      expect(lot).to_not be_valid
    end
  end

  describe 'association' do
    it { should belong_to :box }
    it { should belong_to :freezer_location }
    it { should belong_to :block }
    it { should belong_to :field }
  end

  describe '.net_weight' do
    it 'calculates the net weight of a lot' do
      set_tenant_company
      box = create(:box, empty_weight: 200)
      lot = create(:lot, full_weight: 1000, box_id: box.id)
      new_weight = lot.full_weight - box.empty_weight

      expect(lot.net_weight).to eq new_weight
    end

    context 'with nil box empty_weight' do
      it 'uses default value to calculate net weight of a lot' do
        set_tenant_company
        box = create(:box, empty_weight: nil)
        lot = create(:lot, full_weight: 1000, box_id: box.id)
        net_weight = lot.full_weight - 200

        expect(lot.net_weight).to eq net_weight
      end
    end
  end

  describe 'move_to' do
    context 'with valid destination' do
      it 'updates the lot location attribute' do
        set_tenant_company
        current_location = create(:freezer_location)
        new_location = create(:freezer_location)
        lot = create(:lot, freezer_location_id: current_location.id)

        lot.move_to(new_location)
        lot.reload
        expect(lot.freezer_location_id).to eq new_location.id
      end
    end
  end

  describe '.content_name' do
    it 'returns lot content name' do
      content = create(:content, name: 'contentName')
      lot = Lot.new(content: content)

      expect(lot.content_name).to eq 'contentName'
    end

    context 'when lot has no content' do
      it 'returns empty string' do
        lot = Lot.new

        expect(lot.content_name).to eq ''
      end
    end
  end

  describe '.box_name' do
    it 'returns lot box name' do
      box = build(:box, name: 'boxName')
      lot = Lot.new(box: box)

      expect(lot.box_name).to eq 'boxName'
    end

    context 'when lot has no box' do
      it 'returns empty string' do
        lot = Lot.new

        expect(lot.box_name).to eq ''
      end
    end
  end
end
