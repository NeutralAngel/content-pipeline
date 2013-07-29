require "rspec/helper"

describe Content::Pipeline do
  subject do
    described_class
  end

  let(:filter) do
    subject::Filters::Markdown
  end

  it "populates opts" do
    expect(subject.new(filter, :o1 => 1, :o2 => 2).opts).to eq :o1 => 1, :o2 => 2
  end

  it "populates default filters" do
    expect(subject.new.filters).to eq subject::Filters::DEFAULT_FILTERS
  end

  it "populates filters" do
    expect(subject.new(filter).filters).to eq [ filter ]
  end

  it "runs filters" do
    filter.should_receive(:new).with("# Foo", :o1 => 1, :o2 => 2).and_call_original
    filter.any_instance.should_receive(:run).and_call_original
    expect(subject.new(filter, :markdown => { :o1 => 1 }).
      filter("# Foo", :markdown => { :o2 => 2 })).to match /<h1[^>]*>Foo<\/h1>/
  end
end
