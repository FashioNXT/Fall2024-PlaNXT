# frozen_string_literal: true

class SessionsController < ApplicationController
  def new; end

  def create
    if Rails.env.production?
      @user = User.from_omniauth(request.env['omniauth.auth'])
      logger.info('IN PRODUCTION')
      if @user.present?
        # session[:user_id] = @user.id
        session[:user_email] = @user.email
        redirect_to plans_path, notice: "Logged in successfully as #{@user.email}"
        logger.info(@user.id)
      else
        flash.alert = 'User not found.'
        flash.now[:alert] = 'Invalid request'
        redirect_to root_path, notice: 'Invalid username/email or password'
      end
    else
      logger.info('NOT IN PRODUCTION')
      @user = User.new(name: 'Dummy User', email: 'test@email.com')
      session[:user_email] = @user.email
      redirect_to plans_path, notice: 'Logged in successfully'
    end
  end

  def destroy
    # Clear the user's session (if necessary)
    session[:user_id] = nil

    # Redirect to another web app for logout
    # redirect_to 'https://events360.herokuapp.com/logout', status: :see_other
  end
end
