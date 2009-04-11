module Spec
  module Matchers
    class Include #:nodoc:
      include Spec::Matchers::Pretty

      def initialize(*expecteds)
        @expecteds = expecteds
      end
      
      def matches?(actual)
        @actual = actual
        @expecteds.each do |expected|
          if actual.is_a?(Hash)
            if expected.is_a?(Hash)
              expected.each_pair do |k,v|
                return false unless actual[k] == v
              end
            else
              return false unless actual.has_key?(expected)
            end
          else
            return false unless actual.include?(expected)
          end
        end
        true
      end
      
      def failure_message_for_should
        _message
      end
      
      def failure_message_for_should_not
        _message("not ")
      end
      
      def description
        "include #{_pretty_print(@expecteds)}"
      end
      
      private
        def _message(maybe_not="")
          "expected #{@actual.inspect} #{maybe_not}to include #{_pretty_print(@expecteds)}"
        end
    end

    # :call-seq:
    #   should include(expected)
    #   should_not include(expected)
    #
    # Passes if actual includes expected. This works for
    # collections and Strings. You can also pass in multiple args
    # and it will only pass if all args are found in collection.
    #
    # == Examples
    #
    #   [1,2,3].should include(3)
    #   [1,2,3].should include(2,3) #would pass
    #   [1,2,3].should include(2,3,4) #would fail
    #   [1,2,3].should_not include(4)
    #   "spread".should include("read")
    #   "spread".should_not include("red")
    def include(*expected)
      Matcher.new :include, *expected do |*expecteds|
        match do |actual|
          helper(actual, *expecteds)
        end
        
        def helper(actual, *expecteds)
          expecteds.each do |expected|
            if actual.is_a?(Hash)
              if expected.is_a?(Hash)
                expected.each_pair do |k,v|
                  return false unless actual[k] == v
                end
              else
                return false unless actual.has_key?(expected)
              end
            else
              return false unless actual.include?(expected)
            end
          end
          true
        end
      end
    end
  end
end
