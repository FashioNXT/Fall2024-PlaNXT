# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SessionsController, type: :controller do
  describe '#create (production)' do
    let(:omniauth_auth) do
      OmniAuth::AuthHash.new(
        provider: 'event360',
        uid: '123456',
        info: { email: 'user@example.com', name: 'John Doe' }
      )
    end

    before do
      allow(Rails.env).to receive(:production?).and_return(true)
      request.env['omniauth.auth'] = omniauth_auth
    end

    context 'when user is authenticated' do
      it 'logs in the user and redirects to plans_path' do
        simulate_successful_authentication

        post :create, params: { provider: 'event360' }

        expect_successful_login_response
      end
    end

    context 'when user authentication fails' do
      it 'redirects to sign_in_path with an alert message' do
        simulate_failed_authentication

        post :create, params: { provider: 'event360' }

        expect_failed_login_response
      end
    end
  end

  describe '#create (!production)' do
    it 'logs in a user' do
      user = create_user

      post :create, params: { user: user_params(user) }

      expect(flash[:notice]).to match('Logged in successfully')
    end
  end

  private

  def simulate_successful_authentication
    user = User.new(email: 'user@example.com', name: 'John Doe')
    allow(User).to receive(:from_omniauth).and_return(user)
  end

  def expect_successful_login_response
    expect(session[:user_email]).to eq('user@example.com')
    expect(response).to redirect_to(plans_path)
    expect(flash[:notice]).to eq('Logged in successfully as user@example.com')
  end

  def simulate_failed_authentication
    allow(User).to receive(:from_omniauth).and_return(nil)
  end

  def expect_failed_login_response
    expect(response).to redirect_to(root_path)
    expect(flash[:alert]).to eq('Invalid request')
  end

  def create_user
    User.create(name: 'Any Name', email: 'any@email.com',
                password: 'password', password_confirmation: 'password')
  end

  def user_params(user)
    {
      name: user.name,
      email: user.email,
      password: user.password,
      password_confirmation: user.password_confirmation
    }
  end
end
