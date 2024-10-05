# frozen_string_literal: true

require 'omniauth-oauth2'

module OmniAuth
  module Strategies
    class Events360 < OmniAuth::Strategies::OAuth2
      option :name, :events360

      option :client_options,
             site: ENV['NXT_APP_URL'],
             authorize_path: '/oauth/authorize'

      uid do
        raw_info['id']
      end

      info do
        {
          name: raw_info['name'],
          email: raw_info['email']
        }
      end

      def raw_info
        @raw_info ||= access_token.get('/api/user').parsed
      end
    end
  end
end
