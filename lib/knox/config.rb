module Knox
  module Configure
    attr_writer :base_url, :api_key, :api_password

    KEYS = [:base_url, :api_key, :api_password]

    def config
      yield self
      self
    end

  end
end
