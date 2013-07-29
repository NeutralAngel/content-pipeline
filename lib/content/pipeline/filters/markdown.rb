# ----------------------------------------------------------------------------
# A filter that supports Github-Markdown and also has a few filters to strip
# the most basic unsafe content, if the user chooses this to be done.
# ----------------------------------------------------------------------------

class Content::Pipeline::Filters::Markdown < Content::Pipeline::Filter
  add_filter :markdown, :strip_html

  # --------------------------------------------------------------------------
  # Parse Markdown content.
  # --------------------------------------------------------------------------

  private
  def markdown
    type = @opts.fetch(:type, ((jruby?) ? (:kramdown) : (:gfm)))

    @str = case
    when type =~ /\Amarkdown|gfm\Z/
      require "github/markdown"
      GitHub::Markdown.to_html(@str, @opts.fetch(:type, :gfm)).strip
    else
      require "kramdown"
      fix_kramdown_wraps(Kramdown::Document.
        new(convert_backtick(@str), :enable_coderay => false).to_html).strip
    end
  end

  # --------------------------------------------------------------------------
  # Discovers private methods that start with strip_ and runs them if the
  # filter is in safe mode.  Which will strip certain tags from the data.
  #
  # Doing it this way allows us to allow people to extend this class and add
  # what they wish to it, while us preventing them from monkey patching key
  # methods and having to keep those up-to-date.
  # --------------------------------------------------------------------------

  private
  def strip_html
    @str = @str.to_nokogiri_fragment
    if @opts[:safe]
      private_methods(false).keep_if { |m| m =~ /\Astrip_/ }.each do |m|
        unless m == :strip_html
          send(m)
        end
      end
    end
  end

  # --------------------------------------------------------------------------
  # Strip anchor tags.
  # --------------------------------------------------------------------------

  private
  def strip_links
    @str.search("a").each do |node|
      node.replace(node[:href])
    end
  end

  # --------------------------------------------------------------------------
  # Strip image tags.
  # --------------------------------------------------------------------------

  private
  def strip_image
    @str.search("img").each do |node|
      # Tries to cover single line images wrapped in a paragraph.
      node.parent.children.count == 1 ? node.parent.remove : node.remove
    end
  end

  # --------------------------------------------------------------------------
  # Converts Github style backticks over to Portable ~~~.
  # --------------------------------------------------------------------------

  private
  def convert_backtick(str)
    str.gsub(/^`{3}(\s?[a-zA-Z0-9]+)?$/, "~~~\\1")
  end

  # --------------------------------------------------------------------------
  # Converts <pre><code class="language-ruby"> to <pre lang="lang">.
  # --------------------------------------------------------------------------

  private
  def fix_kramdown_wraps(str)
    str.gsub(/<pre><code class="language-([A-Za-z0-9]+)">/, '<pre lang="\\1"><code>')
  end
end
