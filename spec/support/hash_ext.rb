module RSpec
  module CoreExt
    module HashExt
      def only(*keys)
        keys.inject({}) do |h, k|
          h[k] = self[k]
        h
        end
      end
    end
  end
end

Hash.send(:include, RSpec::CoreExt::HashExt)
