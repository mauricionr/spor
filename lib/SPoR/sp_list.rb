require_relative 'sp_object'
require_relative 'sp_list_item'

module SPoR
  class SPList < SPObject

    def items
      item_url = @metadata['Items']['__deferred']['uri']
      response = SPConnection.instance.send_request :get, item_url
      list_items = []
      response['d']['results'].each do |result|
        list_items << (SPListItem.new result)
      end
      list_items
    end

  end
end
