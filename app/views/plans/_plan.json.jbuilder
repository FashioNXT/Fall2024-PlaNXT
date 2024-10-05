# frozen_string_literal: true

json.extract! plan, :id, :name, :owner, :venue_length, :venue_width, :created_at, :updated_at
json.url plan_url(plan, format: :json)
