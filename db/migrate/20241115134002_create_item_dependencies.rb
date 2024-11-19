class CreateItemDependencies < ActiveRecord::Migration[7.0]
  def change
    create_table :item_dependencies do |t|
      t.integer :item_id
      t.integer :dependency_id

      t.timestamps
    end
    add_index :item_dependencies, :item_id
    add_index :item_dependencies, :dependency_id
  end
end
