class Content::Pipeline::Filters::Markdown < Content::Pipeline::Filter
  class UnknownParserError < StandardError
    def initialize(type)
      super "Unknown parser #{type} provided"
    end
  end

  add_filter({
    :markdown => :str,
    :strip_html => :nokogiri
  })

  private
  def default
    jruby? ? :kramdown : :redcarpet
  end

  private
  def markdown
    @type = @opts.fetch(:type, default)
    @str  = backtick(@str)
    @str  = case
    when @type =~ /\Akramdown\Z/   then parse_kramdown
    when @type =~ /\Agithub|gfm\Z/ then parse_github
    when @type =~ /\Aredcarpet\Z/  then parse_redcarpet
    when @type =~ /\Amarkdown|md\Z/
      begin parse_redcarpet; rescue LoadError
        begin parse_kramdown; rescue LoadError
          parse_github
        end
      end
    else
      # Actually needed now days.
      raise UnknownParserError, @type
    end
  end

  private
  def parse_redcarpet
    require "redcarpet"
    with = Redcarpet::Render::HTML
    (@opts[:parser_opts] ||= {}).merge!({
      :fenced_code_blocks => true
    })

    Redcarpet::Markdown.new(with, @opts[:parser_opts]).render(
      @str
    )
  end

  private
  def parse_github
    require "github/markdown"
    GitHub::Markdown.to_html(@str, @type).strip
  end

  private
  def parse_kramdown
    (@opts[:parser_opts] ||= {}).merge!({
      :enable_coderay => false
    })

    require "kramdown"
    str = Kramdown::Document.new(@str, @opts[:parser_opts])
    normalize_kramdown(str.to_html).strip
  end

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

  private
  def strip_links
    @str.search("a").each do |n|
      n.replace(n[:href])
    end
  end

  private
  def strip_image
    @str.search("img").each do |n|
      n.parent.children.count == 1 ? n.parent.remove : n.remove
    end
  end

  private
  def backtick(str)
    str.gsub(/^`{3}(\s?[a-zA-Z0-9]+)?$/, "~~~\\1")
  end

  private
  def normalize_kramdown(str)
    str.gsub(/<pre><code class="language-([A-Za-z0-9]+)">/, \
      '<pre lang="\\1"><code>')
  end
end
