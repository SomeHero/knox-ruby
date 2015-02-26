module Knox
  # This is used when a customer needs to be defined by the plaid access token.
  # Abstracting as a class makes it easier since we wont have to redefine the access_token over and over.
  class Account

    # This initializes our instance variables, and sets up a new Customer class.
    def initialize
      Knox::Configure::KEYS.each do |key|
        instance_variable_set(:"@#{key}", Knox.instance_variable_get(:"@#{key}"))
      end
    end

    def get_account session_token, account_pin

        base_url = self.instance_variable_get(:'@base_url')

        url = base_url + "/accounts?account_pin=" + account_pin
        response = RestClient.get(url,
          {
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

    def create session_token, bank_username, bank_password, swift_code, store

      base_url = self.instance_variable_get(:'@base_url')

      url = base_url + "/banklogin"

      response = RestClient.post(url, {
        "bank_username" => bank_username,
        "bank_password" => bank_password,
        "swift_code" => swift_code,
        "store" => store
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

    def mfa session_token, answer1, answer2, store

      base_url = self.instance_variable_get(:'@base_url')

      url = base_url + "/securityanswer"

      binding.pry
      response = RestClient.post(url, {
        "answer_1" => answer1,
        "answer_2" => answer2,
        "store" => store
      }, {
          :'authorization' => session_token
      }){ |response, request, result, &block|
          case response.code
          when 200
            response
          when 201
            response
          else
            binding.pry
            response.return!(request, result, &block)
          end
      }

      @parsed_response = Hash.new
      @parsed_response[:code] = response.code

      response = JSON.parse(response)

      return response
    end

    protected

    def parse_response(response,method)
      case method
      when 1
        case response.code
        when 200
          @parsed_response = Hash.new
          @parsed_response[:code] = response.code
          response = JSON.parse(response)
          @parsed_response[:access_token] = response["access_token"]
          @parsed_response[:accounts] = response["accounts"]
          @parsed_response[:transactions] = response["transactions"]
          return @parsed_response
        when 201
          @parsed_response = Hash.new
          @parsed_response[:code] = response.code
          response = JSON.parse(response)
          @parsed_response = Hash.new
          @parsed_response[:type] = response["type"]
          @parsed_response[:access_token] = response["access_token"]
          @parsed_response[:mfa_info] = response["mfa"]
          return @parsed_response
        else
          @parsed_response = Hash.new
          @parsed_response[:code] = response.code
          @parsed_response[:message] = response
          return @parsed_response
        end
      when 2
        case response.code
        when 200
          @parsed_response = Hash.new
          @parsed_response[:code] = response.code
          response = JSON.parse(response)
          @parsed_response[:accounts] = response["accounts"]
          @parsed_response[:transactions] = response["transactions"]
          return @parsed_response
        else
          @parsed_response = Hash.new
          @parsed_response[:code] = response.code
          @parsed_response[:message] = response
          return @parsed_response
        end
      when 3
        case response.code
        when 200
          @parsed_response = Hash.new
          @parsed_response[:code] = response.code
          response = JSON.parse(response)
          @parsed_response[:message] = response
          return @parsed_response
        else
          @parsed_response = Hash.new
          @parsed_response[:code] = response.code
          @parsed_response[:message] = response
          return @parsed_response
        end
      end
    end

    private

    def get(path,access_token,options={})
      base_url = self.instance_variable_get(:'@base_url')

      url = base_url + path
      RestClient.get(url,:params => {:client_id => self.instance_variable_get(:'@customer_id'), :secret => self.instance_variable_get(:'@secret'), :access_token => access_token}){ |response, request, result, &block|
          case response.code
          when 200
            response
          when 201
            response
          else
            response.return!(request, result, &block)
          end
      }
    end

    def post(path,access_token,options={})
      base_url = self.instance_variable_get(:'@base_url')

      url = base_url + path
      RestClient.post url, :client_id => self.instance_variable_get(:'@customer_id') ,:secret => self.instance_variable_get(:'@secret'), :access_token => access_token, :mfa => @mfa, :type => options[:type]{ |response, request, result, &block|
          case response.code
          when 200
            response
          when 201
            response
          else
            response.return!(request, result, &block)
          end
      }
    end

    def patch(path,access_token,type,username,password,options={})
      base_url = self.instance_variable_get(:'@base_url')

      url = base_url + path
      RestClient.patch(url, :client_id => self.instance_variable_get(:'@customer_id') ,:secret => self.instance_variable_get(:'@secret'), :access_token => access_token, :type => type, :credentials => {:username => username, :password => password} ){ |response, request, result, &block|
          case response.code
          when 200
            response
          when 201
            response
          else
            response.return!(request, result, &block)
          end
      }
    end

    def delete(path,access_token,options={})
      base_url = self.instance_variable_get(:'@base_url')

      url = base_url + path
      RestClient.delete(url,:params => {:client_id => self.instance_variable_get(:'@customer_id'), :secret => self.instance_variable_get(:'@secret'), :access_token => access_token}){ |response, request, result, &block|
          case response.code
          when 200
            response
          when 201
            response
          else
            response.return!(request, result, &block)
          end
      }
    end
  end
end
