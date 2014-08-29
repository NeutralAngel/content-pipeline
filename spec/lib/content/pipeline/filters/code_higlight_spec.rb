require "content/pipeline/filters/code_highlight"
require "rspec/helper"

describe Content::Pipeline::Filters::CodeHighlight do
  let(:code) { '<pre lang="ruby"><code>:ruby</code></pre>' }
  let(:lang_free_code) { '<pre><code>"hello"</code></pre>' }
  let(:css) { ">figure.code>div.highlight>table>tbody>tr"  }
  subject { described_class }

  it "highlights syntax" do
    subject.new(code).run.to_nokogiri_fragment.tap do |o|
      expect(o.search("#{css}>td.gutter>pre> span.line-number")).to have(1).item
      expect(o.search("#{css}>td.code>pre>code.ruby>span.line")).to have(1).item
    end
  end

  it "wraps a plain pre and defaults to ruby" do
    subject.new(lang_free_code).run.to_nokogiri_fragment.tap do |o|
      expect(o.search("#{css}>td.gutter>pre> span.line-number").count).to eq 1
      expect(o.search("#{css}>td.code>pre>code.ruby>span.line").count).to eq 1
    end
  end

  it "allows the user to select the default language" do
    subject.new(lang_free_code, :default => \
        :text).run.to_nokogiri_fragment.tap do |o|

      expect(o.search("#{css}>td.gutter>pre> span.line-number").count).to eq 1
      expect(o.search("#{css}>td.code>pre>code.text>span.line").count).to eq 1
    end
  end

  context "with gutter disabled" do
    it "doesn't add the gutter with line numbers" do
      subject.new(code, :gutter => false).run.to_nokogiri_fragment.tap do |o|
        expect(o.search("#{css}>td.gutter>pre> span.line-number")).to have(0).items
        expect(o.search("#{css}>td.code>pre>code.ruby>span.line")).to have(1).item
      end
    end
  end
end
