require 'securerandom'
require 'digest/sha1'

module Knox
  # This is used when a customer needs to be defined by the plaid access token.
  # Abstracting as a class makes it easier since we wont have to redefine the access_token over and over.
  class Pay

    # This initializes our instance variables, and sets up a new Customer class.
    def initialize
      Knox::Configure::KEYS.each do |key|
        instance_variable_set(:"@#{key}", Knox.instance_variable_get(:"@#{key}"))
      end
    end

    def create session_token, total, debit_api_key, credit_api_key

      base_url = self.instance_variable_get(:'@base_url')

      url = base_url + "/pay"
      
      response = RestClient.post(url, {
        "total" => total,
        "debit_pin" => debit_api_key,
        "credit_pin" => credit_api_key
      }, {
          :'authorization' => session_token
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

      @parsed_response = Hash.new
      @parsed_response[:code] = response.code

      response = JSON.parse(response)

      return response
    end

  end
end
