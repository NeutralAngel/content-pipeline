require "gemoji"
require "pry"

class Content::Pipeline::Filters::Gemoji < Content::Pipeline::Filter
  EmojiTag = %Q{<img class="emoji" src="%s" alt=":%s:" height="20" width="20">}
  EmojiPattern = /(?:^\s*|\s+):(#{Emoji.all.map { |n| Regexp.escape(n.name) }.join("|")}):(?:\s+|\s*$)/m
  EmojiLiquidTag = %Q{{%%img "%s" ":%s:" %%}}

  add_filter({
    :gemoji => :nokogiri
  })

  def initialize(*args)
    super(*args)
    # I should make this an addon.
    @opts[:asset_path] ||= "/assets"
  end

  private
  def gemoji
    @str = @str.to_nokogiri_fragment
    [:xpath, :search].each do |t|
      @str.send(t, "text()").each do |n|
        parse_node(n)
      end
    end
  end

  def parse_node(node)
    return node if node.ancestors.any? do |n|
      n.node_name == "code" || n.node_name == "pre"
    end

    node.replace(node.to_html.gsub(EmojiPattern) do
      ep = "#{@opts[:asset_path].chomp("/")}/#{$1}.png"
      en = $1

      if ! @opts[:tag] && ! @opts[:tag].is_a?(Proc)
        if @opts[:as_liquid_asset]
          then EmojiLiquidTag % [ep, en]
          else EmojiTag % [ep, en]
        end
      else
        @opts[:tag].call(ep, en)
      end
    end)
  end
end
