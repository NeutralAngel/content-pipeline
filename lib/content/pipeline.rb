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
        out_opts = opts.values_at(*to_opt(f).uniq)
        out_opts = out_opts.map do |v|
          v || {}
        end

        out_opts = out_opts.reduce(Hash.new, :merge)
        out = f.new(out, out_opts).run
      end

    out
    end

    # -----------------------------------------------------------------

    private
    def to_opt(cls, alt = false)
      cls = cls.name.split(/::/).last
      out = [
        cls.downcase,
        cls[0].downcase + cls[1..-1].gsub(/([A-Z])/) do
          "_" + $1.downcase
        end
      ]

      out.map(&:to_sym)
    end
  end
end
