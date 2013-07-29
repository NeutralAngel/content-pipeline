require "rspec/helper"

describe Content::Pipeline::Filters::CodeHighlight do
  subject do
    described_class
  end

  let :code do
    '<pre lang="ruby"><code>:ruby</code></pre>'
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

  it "wraps a plain pre" do
    Nokogiri::HTML.fragment(subject.new(code.sub(' lang="ruby"', "")).run).tap do |obj|
      expect(obj.search("#{css}>td.gutter>pre> span.line-number")).to have(1).item
      expect(obj.search("#{css}>td.code>pre>code.text>span.line")).to have(1).item
    end
  end
end
