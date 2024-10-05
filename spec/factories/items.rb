# frozen_string_literal: true

FactoryBot.define do
  factory :item do
    name { 'Sample Item' }
    association :step # Ensure that item is associated with a step
    # other attributes as needed
  end
end
