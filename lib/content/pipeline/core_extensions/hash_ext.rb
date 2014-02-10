module CoreExtensions
  module HashExt
    unless method_defined?(:deep_merge)
      def deep_merge(new_hash)
        merge(new_hash) do |k, o, n|
          o.is_a?(Hash) && n.is_a?(Hash) ? o.deep_merge(n) : n
        end
      end
    end
  end
end

Hash.send(:include, CoreExtensions::HashExt)
