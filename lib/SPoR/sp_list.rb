module SPoR
  class SPList
    def initialize(metadata)
      @metadata = metadata
    end

    def method_missing(method_sym, *arguments, &block)
      match = SPListDynamicFinderMatch.new(method_sym)
      if match.match?
        define_dynamic_finder(method_sym, match.attribute)
        send(method_sym)
      else
        super
      end
    end

    def respond_to?(method_sym, include_private = false)
      true
    end


    protected

    def define_dynamic_finder(finder, attribute)
      class_eval <<-RUBY
      def #{finder}                 # def title
        @metadata["#{attribute}"]   #   @metadata["Title"]
      end                           # end
      RUBY
    end

  end


  class SPListDynamicFinderMatch
    attr_accessor :attribute

    def initialize(method_sym)
      @attribute = camelize(method_sym)
    end

    def match?
      @attribute != nil
    end

    private
    #copy from file activesupport/lib/active_support/inflector/methods.rb, line 55
    def camelize(term, uppercase_first_letter = true)
      string = term.to_s
      if uppercase_first_letter
        string = string.sub(/^[a-z\d]*/) { inflections.acronyms[$&] || $&.capitalize }
      else
        string = string.sub(/^(?:#{inflections.acronym_regex}(?=\b|[A-Z_])|\w)/) { $&.downcase }
      end
      string.gsub(/(?:_|(\/))([a-z\d]*)/) { "#{$1}#{inflections.acronyms[$2] || $2.capitalize}" }.gsub('/', '::')
    end
  end
end
