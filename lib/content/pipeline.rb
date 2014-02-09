require_relative "pipeline/core_extensions/object_ext"
require_relative "pipeline/core_extensions/hash_ext"

module Content
  class Pipeline
    require_relative "pipeline/filters"
    attr_reader :filters, :opts

    # -----------------------------------------------------------------
    # @arg Array: The filters you would like to use or next:
    # @arg Hash : Your "default options" that should be "global."
    # -----------------------------------------------------------------

    def initialize(filters = nil, opts = nil)
      if filters.is_a?(Hash) && opts.nil?
        opts = filters
        filters =  nil
      end


      opts = {} if opts.nil?
      filters = Filters::DEFAULT_FILTERS if filters.nil?
      @opts, @filters = opts.freeze, [ filters ].flatten.freeze
    end

    # -----------------------------------------------------------------
    # @arg String: The incomming string that will be modified.
    # @arg Hash  : The secondary opts to override the "defaults".
    # -----------------------------------------------------------------

    def filter(out, opts = {})
      opts = @opts.deep_merge(opts)
      @filters.each_with_index do |f, i|
        fopts = opts.values_at(*to_opt(f)). \
          delete_if(&:nil?).reduce(Hash.new, :merge)

        out = f.new(out, fopts).run(@filters[i + 1])
      end

    out
    end

    # -----------------------------------------------------------------
    # @arg Object: An object (preferably a class or module.)
    # -----------------------------------------------------------------

    private
    def to_opt(cls)
      cls = cls.name.split(/::/).last
      out = [
        cls.downcase,
        cls[0].downcase + cls[1..-1].gsub(/([A-Z])/) do
          "_" + $1.downcase
        end
      ]

      out.uniq.map(&:to_sym)
    end
  end
end
