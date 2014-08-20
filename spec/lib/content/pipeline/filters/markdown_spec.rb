require "content/pipeline/filters/markdown"
require "rspec/helper"

describe Content::Pipeline::Filters::Markdown do
  subject { described_class }

  context "with safe enabled" do
    subject do
      Content::Pipeline.new([ described_class ], {
        :markdown => {
          :safe => true
        }
      })
    end

    it "converts anchors to strs" do
      expect(subject.filter("[Foo](//foo)")).to eq "<p>//foo</p>"
    end

    it "strips images" do
      expect(subject.filter("![Foo](/foo.jpg)")).to be_empty
    end
  end

  it "converts content from markdown to HTML" do
    result = /<h1[^>]*>Foo<\/h1>\n\n<p>Bar\?<\/p>/
    expect(subject.new("# Foo\n\nBar?").run).to match result
  end

  it "can use Kramdown" do
    expect(subject.new("# Foo", :type => :kramdown).run).to eq \
      '<h1 id="foo">Foo</h1>'
  end

  it "it does a fallback" do
    subj = subject.new("# Foo", :type => :markdown)
    allow(subj).to receive(:parse_kramdown).and_return("I Win")
    allow(subj).to receive(:parse_github) { raise LoadError }
    expect(subj.run).to eq "I Win"
  end

  it "raises UnknownParserError on unknown type" do
    expect { subject.new("# Foo", :type => :unknown).run }.to raise_error \
      subject::UnknownParserError
  end

  unless jruby?
    it "can use Github markdown" do
      expect(subject.new("# Foo", :type => :gfm).run).to eq "<h1>Foo</h1>"
    end
  end
end
