# frozen_string_literal: true

class ChangeUserIdToAllowNullInPlans < ActiveRecord::Migration[7.0]
  def change
    change_column_null :plans, :user_id, true
  end
end
