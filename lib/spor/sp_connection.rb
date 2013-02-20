require 'jwt'
require 'rest-client'
require 'uri'
require 'httpi'
require 'singleton'

require_relative 'configuration/config'

module SPoR
  class SPConnection
    include Singleton

    def setup_connection(sp_apptoken = nil, sp_host_url)
      @sp_host_url = sp_host_url
      @sp_online_modus = false

      unless sp_apptoken.nil?
        @sp_online_modus = true
        @app_secret = Config::appsecret
        decoded_apptoken = JWT.decode sp_apptoken, @app_secret, false
        @app_context = {:context => decoded_apptoken['appctx'],
                        :sender => decoded_apptoken['appctxsender'],
                        :server_type => decoded_apptoken['appctxsender'].split('@')[0],
                        :server_id => decoded_apptoken['appctxsender'].split('@')[1]
        }
        @connection_data = {
            :acs_server => JSON.parse(@app_context[:context])['SecurityTokenServiceUri'],
            :aud => decoded_apptoken['aud'],
            :refresh_token => decoded_apptoken['refreshtoken'],
        }
        @connection_data[:access_token] = get_access_token
      end
    end

    def send_request(method, url, post_data = nil)
      if method.nil? or url.nil?
        raise 'parameter is nil'
      end

      response = nil
      headers = {:accept => 'application/json;odata=verbose'}
      headers.merge! @connection_data[:access_token][:authorization]
      case method
        when :post
          formdigest = get_formdigest
          headers.merge!({'X-RequestDigest' => formdigest})
          headers.merge!({:content_type => 'application/json;odata=verbose'})
          if @sp_online_modus
            response = RestClient.post url, post_data, headers
          else
            raise 'not implemented yet'
          end
        when :get
          if @sp_online_modus
            response = RestClient.get url, headers
          else
            #ntlm_request = HTTPI::Request.new
            #ntlm_request.url = url
            #ntlm_request.auth.ntlm(user, pass)
            #response = HTTPI.get ntlm_request
            raise 'not implemented yet'
          end
        when :delete
          "get"
        else
          raise 'not supported method'
      end
      JSON.parse response
    end

    def send_request_by_resource(method, resource, post_data = nil)
      url = @sp_host_url + '/_api/' + resource
      send_request method, url, post_data
    end


    private
    def get_access_token
      post_data = {
          :grant_type => 'refresh_token',
          :client_id => @connection_data[:aud],
          :client_secret => @app_secret,
          :refresh_token => @connection_data[:refresh_token],
          :resource => @app_context[:server_type] + '/' + URI(@sp_host_url).host + '@' + @app_context[:server_id]
      }

      result = RestClient.post @connection_data[:acs_server], post_data

      json_result = JSON.parse(result)
      auth_token = {:token_type => json_result['token_type'], :access_token => json_result['access_token']}
      auth_token[:authorization] = {:Authorization => auth_token[:token_type] + ' ' + auth_token[:access_token]}

      auth_token

    end

    def get_formdigest
      header = {:accept => 'application/json;odata=verbose'}
      header.merge! @connection_data[:access_token][:authorization]
      contextinfo = RestClient.post @sp_host_url + '/_api/contextinfo', '', header
      json_contextinfo = JSON.parse contextinfo
      json_contextinfo['d']['GetContextWebInformation']['FormDigestValue']
    end

  end
end
