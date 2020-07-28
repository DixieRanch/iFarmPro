class AddShipmentIdToLots < ActiveRecord::Migration
  def change
    add_column :lots, :shipment_id, :int
  end
end
