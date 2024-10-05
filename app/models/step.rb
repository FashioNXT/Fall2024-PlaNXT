# frozen_string_literal: true

class Step < ActiveRecord::Base
  belongs_to :plan
  has_many :items, dependent: :destroy
  accepts_nested_attributes_for :items, allow_destroy: true # allows items to be destroyed when step is destroyed
end
