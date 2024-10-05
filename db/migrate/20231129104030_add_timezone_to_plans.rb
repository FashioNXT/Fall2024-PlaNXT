# frozen_string_literal: true

# This is the Migration
class AddTimezoneToPlans < ActiveRecord::Migration[7.0]
  def change
    add_column :plans, :timezone, :string
  end
end
