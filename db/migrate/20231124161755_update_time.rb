# frozen_string_literal: true

# This is the Migration
class UpdateTime < ActiveRecord::Migration[7.0]
  def change
    remove_column :steps, :start_time
    remove_column :steps, :end_time
    remove_column :steps, :break1_start_time
    remove_column :steps, :break1_end_time
    remove_column :steps, :break2_start_time
    remove_column :steps, :break2_end_time

    add_column :steps, :start_time, :datetime
    add_column :steps, :end_time, :datetime
    add_column :steps, :break1_start_time, :datetime
    add_column :steps, :break1_end_time, :datetime
    add_column :steps, :break2_start_time, :datetime
    add_column :steps, :break2_end_time, :datetime
  end
end
