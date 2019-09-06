class Shipment < ActiveRecord::Base
  default_scope { where(company_id: Company.current_id) }
end
