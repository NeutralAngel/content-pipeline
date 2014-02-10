require "nokogiri"

module CoreExtensions
  module ObjectExt
    def jruby?
      RbConfig::CONFIG["ruby_install_name"] == "jruby"
    end

    # -----------------------------------------------------------------

    def to_nokogiri_fragment
      return self if self.is_a?(Nokogiri::HTML::DocumentFragment)
      Nokogiri::HTML.fragment(self.to_s)
    end
  end
end

Object.send(:include, CoreExtensions::ObjectExt)
