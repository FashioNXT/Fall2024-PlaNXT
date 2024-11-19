# frozen_string_literal: true

class Item < ActiveRecord::Base
  belongs_to :step
  #has_and_belongs_to_many :dependencies, class_name: 'Item', join_table: 'item_dependencies', foreign_key: 'item_id', association_foreign_key: 'dependency_id'
  # has_many :item_dependencies, foreign_key: :item_id, dependent: :destroy
  # has_many :dependencies, through: :item_dependencies, source: :dependent_item

  # has_many :inverse_item_dependencies, class_name: 'ItemDependency', foreign_key: :dependent_item_id
  # has_many :dependents, through: :inverse_item_dependencies, source: :item
  # has_many :item_dependencies
  # has_many :dependencies, through: :item_dependencies, source: :dependent_item
  has_and_belongs_to_many :dependencies, class_name: 'Item', join_table: 'item_dependencies', foreign_key: 'item_id', association_foreign_key: 'dependency_id'
end
