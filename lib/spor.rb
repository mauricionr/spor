require 'SPoR/version'
require_relative 'SPoR/sp_connection'
require_relative 'SPoR/sp_web'
require_relative 'SPoR/sp_search'

module SPoR
  extend self

  def connect_to_web(sp_apptoken, sp_host_url)
    if sp_host_url.nil?
      raise 'SharePoint Host Url is empty'
    end
    SPConnection.instance.setup_connection sp_apptoken, sp_host_url
    SPWeb.new
  end

  def connect_to_search(sp_apptoken, sp_host_url)
    if sp_apptoken.nil? or sp_host_url.nil?
      raise 'parameter is empty'
    end
    SPConnection.instance.setup_connection sp_apptoken, sp_host_url
    raise 'not implemented yet'
  end
end
