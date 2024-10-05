# frozen_string_literal: true

FactoryBot.define do
  factory :step do
    start_date { '2021-01-01' }
    start_time { '10:00:00' }
    end_time { '11:00:00' }
    break1_start_time { '10:30:00' }
    break1_end_time { '10:45:00' }
    break2_start_time { '10:30:00' }
    break2_end_time { '10:45:00' }

    association :plan, factory: :plan
  end
end
