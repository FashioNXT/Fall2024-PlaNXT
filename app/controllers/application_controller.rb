# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :set_current_user
  def set_current_user
    # finds user with session data and stores it if present
    @current_user = User.find_by(email: session[:user_email]) if session[:user_email]
  end

  def require_user_logged_in!
    # allows only logged in user
    redirect_to root_path, alert: 'You must be signed in' if @current_user.nil?
  end
end
