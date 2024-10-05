# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ApplicationController, type: :controller do
  controller do
    before_action :require_user_logged_in!

    def index
      render plain: 'Hello'
    end
  end

  let(:user) do
    User.create(name: 'Any Name', email: 'any@email.com', password: 'password', password_confirmation: 'password')
  end

  describe '#require_user_logged_in!' do
    context 'when no user is logged in' do
      before do
        session[:user_email] = nil
      end

      it 'redirects to root path' do
        get :index

        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to eq('You must be signed in')
      end
    end

    context 'when user is logged in' do
      before do
        session[:user_email] = user.email
      end

      it 'allows action' do
        get :index

        expect(response.body).to eq('Hello')
      end
    end
  end
end
