class Content::Pipeline

  # -------------------------------------------------------------------
  # Pipeline is an "abstract" class meant to be inherited from in a
  # defined filter.  It provides a set of base methods, namely
  # initialize which spawns the str not to mention add_filter which
  # allows the filter author to define a set of methods that need to be
  # run on this filter.
  # -------------------------------------------------------------------

  class Filter

    # -----------------------------------------------------------------
    # Initialize.
    # -----------------------------------------------------------------

    def initialize(str, opts = nil)
      @opts, @str = (opts || {}), str
    end

    # -----------------------------------------------------------------
    # Run the set of filters the user wants ran on the filter.
    # -----------------------------------------------------------------

    def run
      self.class.filters.each do |f|
        send(f)
      end

      @str.to_s
    end

    class << self
      attr_reader :filters

      # ---------------------------------------------------------------
      # Allows the author of a filter to set a method to be run on this,
      # filter, without us having to enforce a specific type of name.
      # ---------------------------------------------------------------

      def add_filter(*filters)
        @filters ||= []
        @filters.push(*filters.flatten)
      end
    end
  end

  # -------------------------------------------------------------------

  module Filters
    require_relative "filters/code_highlight"
    require_relative "filters/markdown"

    # -----------------------------------------------------------------
    # A set of default filters that we use if the user does not supply
    # their own filters for us to use.
    # -----------------------------------------------------------------

    DEFAULT_FILTERS = [ Markdown, CodeHighlight ].freeze
  end
end
