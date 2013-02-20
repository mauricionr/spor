module SPoR
  module Config
    module Environment
      extend self

      def load_config
        path = File.join(Rails.root, "config", "spor.yml")
        YAML.load(ERB.new(File.new(path).read).result)
      end
    end
  end
end