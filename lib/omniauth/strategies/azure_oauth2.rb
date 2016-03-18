require 'omniauth/strategies/oauth2'

module OmniAuth
  module Strategies
    class AzureOauth2 < OmniAuth::Strategies::OAuth2
      option :name, 'azure_oauth2'

      option :authorize_options, [:scope]

      option :client_options,
             site: 'https://login.microsoftonline.com',
             authorize_url: '/common/oauth2/v2.0/authorize',
             token_url: '/common/oauth2/v2.0/token'

      uid { raw_info['id'] }

      info do
        {
          name: raw_info['displayName'],
          first_name: raw_info['givenName'],
          last_name: raw_info['surname'],
          email: raw_info['email'] || raw_info['userPrincipalName']
        }
      end

      def raw_info
        @raw_info ||= access_token.get('https://graph.microsoft.com/v1.0/me').parsed
      end
    end
  end
end
