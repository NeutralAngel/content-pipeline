require "rspec/helper"

describe Content::Pipeline::Filters::CodeHighlight do
  let(:code) { '<pre lang="ruby"><code>:ruby</code></pre>' }
  let(:lang_free_code) { '<pre><code>"hello"</code></pre>' }
  let(:css) { ">figure.code>div.highlight>table>tbody>tr"  }

  it "highlights syntax" do
    Nokogiri::HTML.fragment(described_class.new(code).run).tap do |o|
      expect(o.search("#{css}>td.gutter>pre> span.line-number")).to have(1).item
      expect(o.search("#{css}>td.code>pre>code.ruby>span.line")).to have(1).item
    end
  end

  it "wraps a plain pre and defaults to ruby" do
    Nokogiri::HTML.fragment(described_class.new(lang_free_code).run).tap do |o|
      expect(o.search("#{css}>td.gutter>pre> span.line-number").count).to eq 1
      expect(o.search("#{css}>td.code>pre>code.ruby>span.line").count).to eq 1
    end
  end

  it "allows the user to select the default language" do
    Nokogiri::HTML.fragment(described_class.new(lang_free_code, :default => :text).run).tap do |o|
      expect(o.search("#{css}>td.gutter>pre> span.line-number").count).to eq 1
      expect(o.search("#{css}>td.code>pre>code.text>span.line").count).to eq 1
    end
  end
end
