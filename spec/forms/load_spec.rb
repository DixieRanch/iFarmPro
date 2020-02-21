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
end
