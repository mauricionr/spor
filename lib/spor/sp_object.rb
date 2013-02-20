module SPoR
  class SPObject

    def initialize(metadata)
      @metadata = metadata
    end

    def method_missing(method_sym, *arguments, &block)
      define_dynamic_attribute(method_sym, camelize(method_sym.to_s))
      send(method_sym)
    end


    protected
    def define_dynamic_attribute(finder, attribute)
      class_eval <<-RUBY
      def #{finder}                 # def title
        @metadata["#{attribute}"]   #   @metadata["Title"]
      end                           # end
      RUBY
    end

    private
    #copy from file activesupport/lib/active_support/inflector/methods.rb, line 55
    def camelize(term)
      return term if term !~ /_/ && term =~ /[A-Z]+.*/
      term.split('_').map { |e| e.capitalize }.join
    end

  end
end
