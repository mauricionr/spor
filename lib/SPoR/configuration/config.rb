require_relative "environment"

module SPoR
  module Config
    extend self

    def appsecret
      config = Environment::load_config
      config['appsecret']
    end
  end
end