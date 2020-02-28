require 'rails_helper'

describe ContentClass, :not_a_tenant_model do
  describe 'attributes' do
    it { should have_db_column :type }
  end
end
