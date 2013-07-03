module RSpec
  module Helpers
    module ExpectError
      def expect_error(error, &block)
        expect { yield }.to raise_error error
      end
    end
  end
end

RSpec.configure do |config|
  config.include RSpec::Helpers::ExpectError
end
