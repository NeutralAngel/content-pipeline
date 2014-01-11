require_relative "pipeline/core_extensions/object_ext"
require_relative "pipeline/core_extensions/hash_ext"

module Content
  class Pipeline
    require_relative "pipeline/filters"
    attr_reader :filters, :opts

    # -----------------------------------------------------------------

    def initialize(filters = Filters::DEFAULT_FILTERS, opts = {})
      @opts, @filters = opts.freeze, [ filters ].flatten.freeze
    end

    # -----------------------------------------------------------------

    def filter(out, opts = {})
      opts = @opts.deep_merge(opts)
      @filters.each do |f|
        out = f.new(out, opts[to_opt(f)]).run
      end

    out
    end

    # -----------------------------------------------------------------

    private
    def to_opt(cls)
      cls.name.split(/::/).last.downcase.to_sym
    end
  end
end
