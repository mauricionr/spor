require_relative "sp_connection"
require "nokogiri"
module SPoR
  class SPWeb

    def initialize(sp_connection)
      @sp_connection = sp_connection
    end

    def title
      request = 'web/title'
      response = @sp_connection.send_request :get, request
      Nokogiri.XML(response).xpath('//d:Title').first.text
    end

    def lists
      "SPLists"
    end

  end
end
