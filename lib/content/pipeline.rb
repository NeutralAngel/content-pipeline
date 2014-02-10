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
      return out if out.nil? || out.empty? || @filters.empty?

      opts = @opts.deep_merge(opts)
      @filters.each_with_index do |f, i|
        fopts = opts.values_at(*to_opt(f)).delete_if(&:nil?). \
          reduce({}, :merge)

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

      [
        cls.downcase,
        underscore_cls(cls) ].uniq.map(&:to_sym)
    end

    # -----------------------------------------------------------------
    # @arg String: The name of the class you wish to adjust.
    # -----------------------------------------------------------------

    private
    def underscore_cls(cls)
      (cls[0].downcase + cls[1..-1]).gsub(/([A-Z])/) do
        "_" + $1.downcase
      end
    end
  end
end
