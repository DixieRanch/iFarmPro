class CreateContents < ActiveRecord::Migration
  def change
    create_table :contents do |t|
      t.string :name
    end
  end
end
