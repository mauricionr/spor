require_relative 'sp_connection'
require_relative 'sp_list'

module SPoR
  class SPWeb

    def title
      request = 'web/title'
      response = SPConnection.instance.send_request_by_resource :get, request
      response['d']['Title']
    end

    def lists
      request = 'lists'
      response = SPConnection.instance.send_request_by_resource :get, request
      lists = []
      response['d']['results'].each do |result|
        lists << (SPList.new result)
      end
      lists
    end

  end
end
