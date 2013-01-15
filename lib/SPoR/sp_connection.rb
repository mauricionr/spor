require "jwt"
require "rest-client"

module SPoR
  class SPConnection
    def initialize(sp_apptoken, sp_host_url)
      @sp_host_url = sp_host_url
      @app_secret = get_appsecret
      decoded_apptoken = JWT.decode sp_apptoken, @app_secret, false
      @app_context = {:context => decoded_apptoken['appctx'],
                      :sender => decoded_apptoken['appctxsender'],
                      :server_type => @app_context[:sender].split('@')[0],
                      :server_id => @app_context[:sender].split('@')[1]
      }
      @connection_data = {
          :acs_server => JSON.parse(@app_context[:context])['SecurityTokenServiceUrl'],
          :aud => decoded_apptoken['aud'],
          :refresh_token => decoded_apptoken['refreshtoken'],
          :access_token => get_access_token
      }
    end

    def send_request(method, request, post_data = nil)
      if method.nil? or url.nil? or
          raise 'parameter is nil'
      end

      url = @sp_host_url + '/api/' + request
      response = nil
      case method
        when :post
          #response = RestClient.post url, post_data, @connection_data[:access_token]
        when :get
          response = RestClient.get url, @connection_data[:access_token]
        when :delete
          "get"
        else
          raise 'not supported method'
      end
      response
    end


    private
    def get_appsecret

    end

    def get_access_token
      post_data = {
          'grant_type' => 'refresh_token',
          'client_id' => @connection_data[:aud],
          'client_secret' => @app_secret,
          'refresh_token' => @connection_data[:refresh_token],
          'resource' => @app_context[:server_type] + '/' + @sp_host_url + '@' + @app_context[:server_id]
      }

      result = RestClient.post @connection_data[:acs_server], post_data

      json_result = JSON.parse(result)
      auth_token = {:token_type => json_result['token_type'], :access_token => json_result['access_token']}
      auth_token[:authorization] = {'Authorization' => auth_token[:token_type] + auth_token[:access_token]}

      auth_token

    end

  end
end
