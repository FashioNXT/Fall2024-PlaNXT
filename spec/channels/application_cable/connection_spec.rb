# frozen_string_literal: true

# spec/channels/application_cable/connection_spec.rb
require 'rails_helper'

RSpec.describe ApplicationCable::Connection, type: :channel do
  describe 'behaviour' do
    it 'inherits from ActionCable::Connection::Base' do
      expect(ApplicationCable::Connection).to be < ActionCable::Connection::Base
    end

    # Add more test cases here to cover other behaviors of the connection class
  end
end
