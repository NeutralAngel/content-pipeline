require "nokogiri"

module CoreExtensions

  # --------------------------------------------------------------------------
  # Object Extensions.
  # --------------------------------------------------------------------------

  module ObjectExt

    def jruby?
      RbConfig::CONFIG["ruby_install_name"] == "jruby"
    end

    # ------------------------------------------------------------------------
    # Convert an element to a Nokogiri document fragment.
    # ------------------------------------------------------------------------

    def to_nokogiri_fragment
      return self if Nokogiri::HTML::DocumentFragment === self
      Nokogiri::HTML.fragment(respond_to?(:to_html) ? to_html : to_s)
    end
  end
end

# ----------------------------------------------------------------------------

Object.send(:include, CoreExtensions::ObjectExt)
