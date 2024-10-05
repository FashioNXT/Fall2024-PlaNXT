# frozen_string_literal: true

json.extract! item, :id, :name, :model, :width, :length, :depth, :rotation, :description, :xpos, :ypos, :zpos,
              :step_id, :created_at, :updated_at
json.url item_url(item, format: :json)
