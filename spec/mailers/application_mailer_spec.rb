# frozen_string_literal: true

# spec/mailers/application_mailer_spec.rb

require 'rails_helper'

RSpec.describe ApplicationMailer, type: :mailer do
  describe 'example_email' do
    let(:user) do
      User.create(email: 'user@example.com', name: 'John Doe') # Adjust attributes based on your User model
    end

    it 'sends an email to the user' do
      # You might want to set up additional data or context relevant to your mailer here

      # Call the mailer method (assuming you have a method named 'example_email' in your mailer)
      mail = described_class.example_email(user)
      expect(mail.subject).to eq('Subject of the email')
      expect(mail.to).to eq([user.email])
    end
  end
end
