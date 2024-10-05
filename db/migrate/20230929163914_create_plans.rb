# frozen_string_literal: true

# This is the Migration
class CreatePlans < ActiveRecord::Migration[7.0]
  def change
    create_table :plans do |t|
      t.string :name
      t.string :owner
      t.float :venue_length
      t.float :venue_width
      t.timestamps
    end
  end
end
