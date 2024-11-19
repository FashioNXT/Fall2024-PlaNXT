class CreateItemDependencies < ActiveRecord::Migration[7.0]
  def change
    create_table :item_dependencies do |t|
      t.integer :item_id
      t.integer :dependency_id

      t.timestamps
    end
  end
end
