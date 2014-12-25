require 'securerandom'
require 'digest/sha1'

module Knox
  # This is used when a customer needs to be defined by the plaid access token.
  # Abstracting as a class makes it easier since we wont have to redefine the access_token over and over.
  class Session

    def initialize
      Knox::Configure::KEYS.each do |key|
        instance_variable_set(:"@#{key}", Knox.instance_variable_get(:"@#{key}"))
      end
    end

    def get_token

      base_url = self.instance_variable_get(:'@base_url')

      #API token is SHA(salt + API_password)
      api_key = self.instance_variable_get(:'@api_key')
      api_password = self.instance_variable_get(:'@api_password')
      salt = SecureRandom.hex
      api_token = Digest::SHA1.hexdigest(salt + api_password)

      url = base_url + "/sessions"

      response = RestClient.post(url, {
        "api_key" => api_key,
        "api_token" => api_token,
        "salt" => salt
      }){ |response, request, result, &block|
          case response.code
          when 200
            response
          when 201
            response
          else
            response.return!(request, result, &block)
          end
      }

      parsed_response = Hash.new
      parsed_response[:code] = response.code
      response = JSON.parse(response)

      return response["session_secret"]

    end

  end
end
