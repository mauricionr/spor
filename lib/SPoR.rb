require "SPoR/version"
require_relative "SPoR/sp_connection"
require_relative "SPoR/sp_web"
require_relative "SPoR/sp_search"

module SPoR
  def self.connect_to_web(sp_apptoken, sp_host_url)
    if sp_apptoken.nil? or sp_host_url
      raise "parameter is empty"
    end
    sp_connection = new SPConnection sp_apptoken, sp_host_url
    return new SPWeb sp_connection
  end

  def self.connect_to_search(sp_apptoken, sp_host_url)
    if sp_apptoken.nil? or sp_host_url.nil?
      raise "parameter is empty"
    end
    sp_connection = new SPConnection sp_apptoken, sp_host_url

  end
end
