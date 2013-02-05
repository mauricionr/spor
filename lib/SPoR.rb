require "SPoR/version"
require_relative "SPoR/sp_connection"
require_relative "SPoR/sp_web"
require_relative "SPoR/sp_search"

module SPoR
  def self.connect_to_web(sp_apptoken, sp_host_url)
    if sp_host_url.nil?
      raise "SharePoint Host Url is empty"
    end
    connectionargs = {:sp_apptoken => sp_apptoken, :sp_host_url => sp_host_url}
    sp_connection = SPConnection.new connectionargs

    return SPWeb.new sp_connection
  end

  def self.connect_to_search(sp_apptoken, sp_host_url)
    if sp_apptoken.nil? or sp_host_url.nil?
      raise "parameter is empty"
    end
    connectionargs = {:sp_apptoken => sp_apptoken, :sp_host_url => sp_host_url}
    sp_connection = SPConnection.new connectionargs

  end
end
