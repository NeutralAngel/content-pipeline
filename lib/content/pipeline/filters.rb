require "forwardable"

class Content::Pipeline
  class Filter
    extend Forwardable

    def_delegator "self.class.filters", :each_with_index
    def_delegator "self.class.filters", :each
    def_delegator "self.class.filters", :size
    def_delegator "self.class.filters", :[]
    def_delegator "self.class", :filters

    def initialize(str, opts = nil)
      @opts, @str = (opts || {}), str
    end

    def run(next_filter = nil)
      return @str unless size > 0

      each_with_index do |f, i|
        send(f.first)

        unless size == i + 1 || @str.is_a?(String) || \
            self[i + 1].last == :nokogiri

          @str = @str.to_s
        end
      end

      next_filter = next_filter.filters.first if next_filter
      if ! next_filter || next_filter.last != :nokogiri
        return @str.to_s
      end

      @str
    end

    class << self
      attr_reader :filters

      def add_filter(*filters)
        @filters ||= []

        filters.each do |f|
          if f.is_a?(Hash)
            f.each do |k, v|
              @filters.push([
                k, v
              ])
            end
          else
            @filters.push([
              f,
              :str
            ])
          end
        end
      end
    end
  end

  module Filters
    require_relative "filters/markdown"
    DEFAULT_FILTERS = [ Markdown ].freeze
  end
end
