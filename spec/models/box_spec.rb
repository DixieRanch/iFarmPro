require 'rails_helper'

describe Box do
  describe 'attributes' do
    it { should have_db_column :name }
    it { should have_db_column :empty_weight }
    it { should have_db_column :company_id }
  end
end
