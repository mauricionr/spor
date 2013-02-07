require_relative "sp_connection"
require_relative "sp_list"

module SPoR
  class SPWeb

    def initialize(sp_connection)
      @sp_connection = sp_connection
    end

    def title
      request = 'web/title'
      response = @sp_connection.send_request :get, request
      response['d']['Title']
    end

    def lists
      request = "lists"
      response = @sp_connection.send_request :get, request
      lists = []
      response['d']['results'].each do |result|
        lists << (SPList.new result)
      end
      lists
    end

  end
end
