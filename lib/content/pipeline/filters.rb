class Content::Pipeline
  class Filter
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

    # -----------------------------------------------------------------

    class << self
      attr_reader :filters

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
    DEFAULT_FILTERS = [ Markdown, CodeHighlight ].freeze
  end
end
