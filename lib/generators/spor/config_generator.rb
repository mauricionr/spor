module Spor
  module Generators
    class ConfigGenerator < Rails::Generators::Base
      desc 'Create a SPoR Configuation at RAILSROOT/config/spor.yml'

      source_root File.expand_path('../templates', __FILE__)

        def create_config_file
          template 'spor.yml', File.join('config', 'spor.yml')
        end

    end
  end
end