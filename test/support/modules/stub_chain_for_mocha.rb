
module StubChainMocha
  module Object
    # Source: http://blog.leshill.org/blog/2009/08/05/update-for-stub-chain-for-mocha.html
    def stub_chain(*methods)
      if methods.length > 1
        next_in_chain = ::Object.new
        stubs(methods.shift).returns(next_in_chain)
        next_in_chain.stub_chain(*methods)
      else
        stubs(methods.shift)
      end
    end

    def expect_chain(*methods)
      if methods.length > 1
        next_in_chain = ::Object.new
        expects(methods.shift).returns(next_in_chain)
        next_in_chain.expect_chain(*methods)
      else
        expects(methods.shift)
      end
    end

    def not_expect_chain(*methods)
      if methods.length > 1
        next_in_chain = ::Object.new
        stubs(methods.shift).returns(next_in_chain)
        next_in_chain.not_expect_chain(*methods)
      else
        expects(methods.shift).never
      end
    end
  end
end

Object.send(:include, StubChainMocha::Object)
