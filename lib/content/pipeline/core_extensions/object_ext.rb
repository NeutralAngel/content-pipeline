require 'nokogiri'

module CoreExtensions

  # --------------------------------------------------------------------------
  # Object Extensions.
  # --------------------------------------------------------------------------

  module ObjectExt

    # ------------------------------------------------------------------------
    # Convert an element to a Nokogiri document fragment.
    # ------------------------------------------------------------------------

    def to_nokogiri_fragment
      return self if Nokogiri::HTML::DocumentFragment === self
      Nokogiri::HTML.fragment(respond_to?(:to_html) ? to_html : to_s)
    end

    # ------------------------------------------------------------------------
    # Require a file with a fallback and if all else fails send an error.
    # ------------------------------------------------------------------------

    def require_or_fail(a, b, msg)
      require a
    rescue LoadError
      begin
        require b
      rescue LoadError => error
        # Try to keep the call chain proper.
        raise LoadError, msg, error.backtrace[3...-1]
      end
    end
  end
end

# ----------------------------------------------------------------------------

Object.send(:include, CoreExtensions::ObjectExt)
