# frozen_string_literal: true

class Item < ActiveRecord::Base
  belongs_to :step
  has_and_belongs_to_many :dependencies, class_name: 'Item', join_table: 'item_dependencies', foreign_key: 'item_id', association_foreign_key: 'dependency_id'
end
