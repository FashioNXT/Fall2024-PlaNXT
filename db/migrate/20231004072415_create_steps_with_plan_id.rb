# frozen_string_literal: true

# This is the Migration
class CreateStepsWithPlanId < ActiveRecord::Migration[7.0]
  def change
    create_table :steps do |t|
      t.date :start_date
      t.time :start_time
      t.time :end_time
      t.time :break1_start_time
      t.time :break1_end_time
      t.time :break2_start_time
      t.time :break2_end_time
      t.integer :plan_id

      t.timestamps
    end

    add_foreign_key :steps, :plans
  end
end
