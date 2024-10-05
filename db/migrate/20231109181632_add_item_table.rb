# frozen_string_literal: true

class AddItemTable < ActiveRecord::Migration[7.0]
  def change
    create_table :items do |t|
      t.string :name
      t.string :model
      t.float :width
      t.float :length
      t.float :depth
      t.float :rotation
      t.string :description
      t.float :xpos
      t.float :ypos
      t.float :zpos
      t.integer :step_id

      t.timestamps
    end

    add_foreign_key :items, :steps
  end
end
