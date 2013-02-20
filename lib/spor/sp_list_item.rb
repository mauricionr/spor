require_relative 'sp_object'
require_relative 'sp_connection'
require_relative 'sp_field_values'

module SPoR
  class SPListItem < SPObject
    attr_reader :values, :html_values

    def initialize(metadata)
      super metadata
      html_field_values = SPConnection.instance.send_request :get, @metadata['FieldValuesAsHtml']['__deferred']['uri']
      field_values = SPConnection.instance.send_request :get, @metadata['FieldValuesAsText']['__deferred']['uri']

      @values = SPFieldValues.new field_values['d']
      @html_values = SPFieldValues.new html_field_values['d']
    end


  end
end
