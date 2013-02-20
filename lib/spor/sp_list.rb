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

    def add_item(values = {})
      json = {'__metadata' => {'type' => list_item_entity_type_full_name}}
      json.merge! values
      SPConnection.instance.send_request :post, @metadata['Items']['__deferred']['uri'], json.to_json
    end

    def upload_file(options = {})

      folder_name = options.key?(:folder_name) ? options[:folder_name] : 'RootFolder'
      file_name = options.key?(:file_name) ? options[:file_name] : raise('no filename given')
      overwrite = options.key?(:overwrite) ? options[:overwrite] : false
      file_content = options.key?(:file_content) ? options[:file_content] : raise('no file content given')

      url = @metadata['__metadata']['uri'] + '/' + folder_name + "/Files/add(url='#{file_name}',overwrite=#{overwrite})"
      SPConnection.instance.send_request :post, url, file_content
    end
  end
end
