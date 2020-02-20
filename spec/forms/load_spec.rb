require 'rails_helper'

describe Load do
  describe 'attributes' do
    it { should respond_to :location }
    it { should respond_to :lots }
  end
end
