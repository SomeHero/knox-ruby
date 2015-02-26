require 'securerandom'
require 'digest/sha1'

module Knox
  # This is used when a customer needs to be defined by the plaid access token.
  # Abstracting as a class makes it easier since we wont have to redefine the access_token over and over.
  class Transactions

    # This initializes our instance variables, and sets up a new Customer class.
    def initialize
      Knox::Configure::KEYS.each do |key|
        instance_variable_set(:"@#{key}", Knox.instance_variable_get(:"@#{key}"))
      end
    end

    def get session_token, from_date, to_date

      base_url = self.instance_variable_get(:'@base_url')

      url = base_url + "/transactions"

      binding.pry
      response = RestClient.get(url, {
        :'authorization' => session_token,
        :'from_date' => from_date,
        :'to_date' => to_date
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

      binding.pry
      @parsed_response = Hash.new
      @parsed_response[:code] = response.code

      response = JSON.parse(response)

      return response
    end

  end
end
