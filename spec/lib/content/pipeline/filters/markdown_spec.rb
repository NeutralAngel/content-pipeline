require 'rspec/helper'

describe Content::Pipeline::Filters::Markdown do
  subject do
    described_class
  end

  it 'converts anchors back to strings if safe is enable' do
    expect(subject.new("[Foo](//foo)", :safe => true).run).to eq "<p>//foo</p>"
  end

  it 'strips images if safe is enabled' do
    expect(subject.new("![Foo](/foo.jpg)", :safe => true).run).to be_empty
  end

  it 'converts content from markdown to HTML' do
    expect(subject.new("# Foo\n\nBar?").run).to eq "<h1>Foo</h1>\n\n<p>Bar?</p>"
  end
end
