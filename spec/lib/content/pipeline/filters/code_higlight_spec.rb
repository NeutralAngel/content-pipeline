require "rspec/helper"
require "pry"

describe Content::Pipeline::Filters::CodeHighlight do
  subject do
    described_class
  end

  let :code do
    '<pre lang="ruby"><code>:ruby</code></pre>'
  end

  let :lang_free_code do
    '<pre><code>"hello"</code></pre>'
  end

  let :css do
    ">figure.code>div.highlight>table>tbody>tr"
  end

  it "highlights syntax" do
    Nokogiri::HTML.fragment(subject.new(code).run).tap do |obj|
      expect(obj.search("#{css}>td.gutter>pre> span.line-number")).to have(1).item
      expect(obj.search("#{css}>td.code>pre>code.ruby>span.line")).to have(1).item
    end
  end

  it "wraps a plain pre and defaults to ruby" do
    Nokogiri::HTML.fragment(subject.new(lang_free_code).run).tap do |obj|
      expect(obj.search("#{css}>td.gutter>pre> span.line-number").count).to eq 1
      expect(obj.search("#{css}>td.code>pre>code.ruby>span.line").count).to eq 1
    end
  end

  it "allows the user to select the default language" do
    Nokogiri::HTML.fragment(subject.new(lang_free_code, :default => :text).run).tap do |obj|
      expect(obj.search("#{css}>td.gutter>pre> span.line-number").count).to eq 1
      expect(obj.search("#{css}>td.code>pre>code.text>span.line").count).to eq 1
    end
  end
end
