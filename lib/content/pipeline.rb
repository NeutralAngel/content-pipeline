require_relative 'pipeline/core_extensions/object_ext'
require_relative 'pipeline/core_extensions/hash_ext'
$:.unshift(File.expand_path('../../', __FILE__))

module Content

  # --------------------------------------------------------------------------
  # Content pipeline is a class that runs content through a pipeline of user
  # set and/or defined filters returning the final result.  It can be mixed
  # and matched anyway and filters can even be skipped and removed.
  # --------------------------------------------------------------------------

  class Pipeline
    require_relative 'pipeline/filters'
    attr_reader :filters, :opts

    # ------------------------------------------------------------------------
    # Allows the user to initialize with a custom set of filters or to auto
    # load our filters and use them, the base filters we provider are
    # redcarpet and pygments.
    #
    # @opt filters [Array] a list of filters to use.
    # ------------------------------------------------------------------------

    def initialize(filters = Filters::DEFAULT_FILTERS, opts = nil)
      @opts, @filters = (opts || {}).freeze, [ filters ].flatten.freeze
    end

    # ------------------------------------------------------------------------
    # Runs through each of the extensions chosen by the user and then calls
    # them, returning the final result as the final HTML string.
    # ------------------------------------------------------------------------

    def filter(content, opts = nil)
      opts = @opts.deep_merge(opts || {})
      @filters.each do |filter|
        content = filter.new(content, opts[to_opt(filter)]).run
      end

      content
    end

    # ------------------------------------------------------------------------
    # Convert a class and it's name into an opt by splitting up it's name
    # and downcasing the last part returning it as a symbol for opts.
    # ------------------------------------------------------------------------

    private
    def to_opt(cls)
      cls.name.split(/::/).last.downcase.to_sym
    end
  end
end
