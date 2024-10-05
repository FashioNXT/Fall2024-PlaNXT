# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: 'from@example.com'
  layout 'mailer'

  def example_email(user)
    @user = user
    mail(to: @user.email, subject: 'Subject of the email')
  end
end
