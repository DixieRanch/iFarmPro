class CreateContentClasses < ActiveRecord::Migration
def change
    create_table :content_classes do |t|
      t.string :grade
      t.timestamps
    end
  end
end
