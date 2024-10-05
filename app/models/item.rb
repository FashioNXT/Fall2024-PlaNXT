# frozen_string_literal: true

class Item < ActiveRecord::Base
  belongs_to :step
end
