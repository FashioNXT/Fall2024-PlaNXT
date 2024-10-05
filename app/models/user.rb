# frozen_string_literal: true

class User < ApplicationRecord
  # adds virtual attributes for authentication
  has_secure_password
  # validates user_name
  validates :name, presence: true, uniqueness: true
  # validates email
  validates :email, presence: true, uniqueness: true,
                    format: { with: /\A[^@\s]+@[^@\s]+\z/, message: 'Invalid email' }

  # relationship with Floorplan
  # has_many :plans

  def self.from_omniauth(access_token)
    data = access_token.info
    email = data['email']
    name = data['name']
    password = SecureRandom.urlsafe_base64(20).tr('lIO0', 'sxyz')

    # User.find_or_create_by(email:)
    where(email:).first_or_create do |user|
      user.email = email
      user.name = name
      user.password = password
      user.password_confirmation = password
      # user.initial_access = Time.now
      # user.last_access    = Time.now
    end
  end
end
