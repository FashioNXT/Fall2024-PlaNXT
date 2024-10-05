# frozen_string_literal: true

class DropStepsTable < ActiveRecord::Migration[7.0]
  def change
    drop_table :steps
  end
end
