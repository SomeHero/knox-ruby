require 'knox/config'
require 'knox/account'
require 'knox/banks'
require 'knox/session'
require 'knox/pay'
require 'rest_client'

module Knox
  class << self
    include Knox::Configure

    # Defined when a user exists with a unique access_token. Ex: Plaid.customer.get_transactions
    def account
      @account = Knox::Account.new
    end

    def banks
      @banks = Knox::Banks.new
    end

    def pay
      @pay = Knox::Pay.new
    end
    # Defined for generic calls without access_tokens required. Ex: Plaid.call.add_accounts(username,password,type)
    def session
      @session = Knox::Session.new
    end

  end
end
