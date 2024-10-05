# frozen_string_literal: true

class Steps < ActiveRecord::Migration[7.0]
  def change
    create_table 'steps' do |t|
      t.date 'start_date'
      t.time 'start_time'
      t.time 'end_time'
      t.time 'break1_start_time'
      t.time 'break1_end_time'
      t.time 'break2_start_time'
      t.time 'break2_end_time'
      # Add fields that let Rails automatically keep track
      # of when movies are added or modified:
      t.timestamps
    end
  end
end
