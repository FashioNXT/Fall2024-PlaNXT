# frozen_string_literal: true

# This is the Migration
class ItemAddTime < ActiveRecord::Migration[7.0]
  def change
    add_column :items, :start_time, :time
    add_column :items, :end_time, :time
    add_column :items, :breakdown_start_time, :time
    add_column :items, :breakdown_end_time, :time
  end
end
