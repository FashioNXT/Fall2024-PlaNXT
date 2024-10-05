# frozen_string_literal: true

# spec/channels/application_cable/channel_spec.rb
require 'rails_helper'

RSpec.describe ApplicationCable::Channel, type: :channel do
  # You can write individual test cases within this block
  describe 'behaviour' do
    it 'inherits from ActionCable::Channel::Base' do
      expect(ApplicationCable::Channel).to be < ActionCable::Channel::Base
    end

    # Add more test cases here to cover other behaviors of the channel class
  end
end
