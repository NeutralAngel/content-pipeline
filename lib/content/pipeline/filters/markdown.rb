class Content::Pipeline::Filters::Markdown < Content::Pipeline::Filter
  add_filter({
    :markdown => :str,
    :strip_html => :nokogiri
  })

  # ---------------------------------------------------------------------------

  private
  def default
    jruby? ? :kramdown : :gfm
  end

  # ---------------------------------------------------------------------------

  private
  def markdown
    @type = @opts.fetch(:type, default)
    @str = backtick(@str)
    @str = case
      when @type =~ /\Amd|markdown|gfm\Z/ then parse_github
    else
      parse_kramdown
    end
  end

  # ---------------------------------------------------------------------------

  private
  def parse_github
    require "github/markdown"
    GitHub::Markdown.to_html(@str, @type).strip
  end

  # ---------------------------------------------------------------------------

  private
  def parse_kramdown
    require "kramdown"
    str = Kramdown::Document.new(@str, {
      :enable_coderay => false
    })

    # For consistent output, like it ok?!
    normalize_kramdown(str.to_html).strip
  end

  # ---------------------------------------------------------------------------

  private
  def strip_html
    if @opts[:safe]
      @str = @str.to_nokogiri_fragment
      private_methods(false).keep_if { |m| m =~ /\Astrip_/ }.each do |m|
        unless m == :strip_html
          send(m)
        end
      end
    end
  end

  # ---------------------------------------------------------------------------

  private
  def strip_links
    @str.search("a").each do |n|
      n.replace(n[:href])
    end
  end

  # ---------------------------------------------------------------------------

  private
  def strip_image
    @str.search("img").each do |n|
      n.parent.children.count == 1 ? n.parent.remove : n.remove
    end
  end

  # ---------------------------------------------------------------------------
  # @arg String: The Markdown string, convert `` to ~~~.
  # ---------------------------------------------------------------------------

  private
  def backtick(str)
    str.gsub(/^`{3}(\s?[a-zA-Z0-9]+)?$/, "~~~\\1")
  end

  # ---------------------------------------------------------------------------
  # @arg String: The converted Markdown string, from Kramdown.
  # ---------------------------------------------------------------------------

  private
  def normalize_kramdown(str)
    str.gsub(/<pre><code class="language-([A-Za-z0-9]+)">/, '<pre lang="\\1"><code>')
  end
end
