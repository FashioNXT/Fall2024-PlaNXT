# frozen_string_literal: true

class Item < ActiveRecord::Base
  belongs_to :step

  # Items that this item depends on
  has_and_belongs_to_many :dependencies,
                          class_name: 'Item',
                          join_table: 'item_dependencies',
                          foreign_key: 'item_id',
                          association_foreign_key: 'dependency_id'

  # Items that depend on this item
  has_and_belongs_to_many :reverse_dependencies,
                          class_name: 'Item',
                          join_table: 'item_dependencies',
                          foreign_key: 'dependency_id',
                          association_foreign_key: 'item_id'
end
