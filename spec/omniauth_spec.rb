# frozen_string_literal: true

require 'spec_helper'

describe OmniAuth::Strategies::Events360 do
  before(:all) do
    ENV['NXT_APP_URL'] = 'https://events360.herokuapp.com'
  end

  subject do
    OmniAuth::Strategies::Events360.new({})
  end

  describe 'strategy initialization' do
    it 'initializes with correct name' do
      expect(subject.options.name).to eq(:events360)
    end

    it 'initializes with correct client options' do
      expect(subject.options.client_options.site).to eq(ENV['NXT_APP_URL'])
      expect(subject.options.client_options.authorize_path).to eq('/oauth/authorize')
    end
  end

  describe '#uid' do
    it 'returns the user id from raw_info' do
      allow(subject).to receive(:raw_info).and_return({ 'id' => '123' })
      expect(subject.uid).to eq('123')
    end
  end

  describe '#info' do
    it 'returns the name and email from raw_info' do
      allow(subject).to receive(:raw_info).and_return({ 'name' => 'John Doe', 'email' => 'john@example.com' })
      expect(subject.info).to eq({ name: 'John Doe', email: 'john@example.com' })
    end
  end

  describe '#raw_info' do
    it 'performs a GET to /api/user' do
      access_token = double('AccessToken')
      response = double('Response', parsed: { 'id' => '123', 'name' => 'John Doe', 'email' => 'john@example.com' })
      allow(access_token).to receive(:get).with('/api/user').and_return(response)
      allow(subject).to receive(:access_token).and_return(access_token)

      expect(subject.raw_info).to eq({ 'id' => '123', 'name' => 'John Doe', 'email' => 'john@example.com' })
    end
  end
end
