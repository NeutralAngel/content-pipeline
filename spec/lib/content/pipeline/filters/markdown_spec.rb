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

    it "strips images" do
      expect(subject.filter("![Foo](/foo.jpg)")).to be_empty
    end

    it "converts anchors back to strings" do
      expect(subject.filter("[Foo](//foo)")).to eq "<p>//foo</p>"
    end
  end

  it "converts content from markdown to HTML" do
    result = /<h1[^>]*>Foo<\/h1>\n\n<p>Bar\?<\/p>/
    expect(subject.new("# Foo\n\nBar?").run).to match result
  end

  unless jruby?
    it "lets you select which markdown you wish to use" do
      expect(subject.new("# Foo", :type => :gfm).run).to eq "<h1>Foo</h1>"
      expect(subject.new("# Foo", :type => :kramdown).run).to eq '<h1 id="foo">Foo</h1>'
    end
  end
end
