# frozen_string_literal: true

# spec/models/user_spec.rb

require 'rails_helper'

RSpec.describe User, type: :model do
  describe '.from_omniauth' do
    let(:access_token_data) do
      {
        'email' => 'test@example.com',
        'name' => 'Test User'
      }
    end

    it 'creates a user from OmniAuth data' do
      expect do
        user = described_class.from_omniauth(OpenStruct.new(info: access_token_data))
        expect(user.email).to eq('test@example.com')
        expect(user.name).to eq('Test User')
        expect(user).to be_persisted
      end.to change { User.count }.by(1)
    end

    it 'returns an existing user if the email already exists' do
      # Create a user manually without FactoryBot
      existing_user = User.create(email: 'test@example.com', name: 'Test', password: 'password',
                                  password_confirmation: 'password')

      # puts existing_user.errors.full_messages
      expect do
        user = described_class.from_omniauth(OpenStruct.new(info: access_token_data))
        expect(user.email).to eq(existing_user.email)
        expect(user.name).to eq(existing_user.name)
      end.not_to(change { User.count })
    end
  end
end
