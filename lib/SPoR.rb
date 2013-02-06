require "SPoR/version"
require_relative "SPoR/sp_connection"
require_relative "SPoR/sp_web"
require_relative "SPoR/sp_search"

module SPoR
  extend self

  def connect_to_web(sp_apptoken, sp_host_url)
    if sp_host_url.nil?
      raise "SharePoint Host Url is empty"
    end
    sp_connection = SPConnection.new({:sp_apptoken => sp_apptoken, :sp_host_url => sp_host_url})
    SPWeb.new sp_connection
  end

  def connect_to_search(sp_apptoken, sp_host_url)
    if sp_apptoken.nil? or sp_host_url.nil?
      raise "parameter is empty"
    end
    sp_connection = SPConnection.new({:sp_apptoken => sp_apptoken, :sp_host_url => sp_host_url})

  end
end
