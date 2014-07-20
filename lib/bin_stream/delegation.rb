module BinStream
  # Simple delegation helper
  #
  # @api private
  module Delegation
    # Generates delegation methods
    # @param [Array<Symbol>] methods names of methods to delegate
    # @param [Hahs] options
    # @option options [Symbol|String] :to name of the attribute to delegate to.
    #
    # @example
    #   class A
    #     def foo
    #       puts "foo"
    #     end
    #
    #     def bar(*args)
    #       puts *args
    #     end
    #   end
    #
    #   class B
    #     attr_accessor :bar
    #
    #     extend Delegation
    #     delegate :foo, :bar to: :baz
    #   end
    #
    #   b = B.new
    #   b.bar = A.new
    #   b.foo           # => foo
    #   b.bar 42        # => 42
    #
    # @return [Array<Symbol>] delegated method names
    # @api private
    def delegate(*methods, options)
      target = options.fetch(:to)

      methods.each do |method_name|
        define_method method_name, -> *args {
          send(target).send(method_name, *args)
        }
      end
    end
  end
end
