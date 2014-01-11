class Content::Pipeline::Filters::Markdown < Content::Pipeline::Filter
  add_filter :markdown, :strip_html

  private
  def default_markdown
    (jruby?) ? :kramdown : :gfm
  end

  # -------------------------------------------------------------------

  private
  def markdown
    type = @opts.fetch(:type, default_markdown)
    @str = convert_backtick(@str)

    @str = case
    when type =~ /\Amarkdown|gfm\Z/
      require "github/markdown"
      GitHub::Markdown.to_html(@str, type).strip
    else
      require "kramdown"
      str = Kramdown::Document.new(@str, :enable_coderay => false)
      normalize_kramdown(str.to_html).strip
    end
  end

  # -------------------------------------------------------------------

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

  # -------------------------------------------------------------------

  private
  def strip_links
    @str.search("a").each do |n|
      n.replace(n[:href])
    end
  end

  # -------------------------------------------------------------------

  private
  def strip_image
    @str.search("img").each do |n|
      n.parent.children.count == 1 ? n.parent.remove : n.remove
    end
  end

  # -------------------------------------------------------------------

  private
  def convert_backtick(str)
    str.gsub(/^`{3}(\s?[a-zA-Z0-9]+)?$/, "~~~\\1")
  end

  # -------------------------------------------------------------------

  private
  def normalize_kramdown(str)
    str.gsub(/<pre><code class="language-([A-Za-z0-9]+)">/, '<pre lang="\\1"><code>')
  end
end
