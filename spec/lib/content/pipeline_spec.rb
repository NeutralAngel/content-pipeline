require "rspec/helper"

describe Content::Pipeline do
  let(:filter) { subject::Filters::Markdown }
  subject { described_class }

  let(:opts) do
    {
      :o1 => 1,
      :o2 => 2
    }
  end

  it "allows a custom set of filters" do
    expect(subject.new(filter).filters).to eq [
      filter
    ]
  end

  describe "#initialize" do
    it "allows opts as the first arg instead of filters:[]" do
      expect(subject.new(opts).opts).to eq(opts)
      expect(subject.new(opts).filters).not_to be_empty
    end
  end

  it "runs filters" do
    filter.should_receive(:new).with("# Foo", anything()).and_call_original
    filter.any_instance.should_receive(:run).and_call_original
    expect(subject.new(filter).filter("# Foo")).to match /<h1[^>]*>Foo<\/h1>/
  end

  describe "#to_opt" do
    let(:filter) { subject::Filters::CodeHighlight }

    it "outputs single_word and singleword from SingleWord" do
      expect(subject.new.send(:to_opt, filter)).to eq [
        :codehighlight, :code_highlight
      ]
    end
  end

  it "populates #opts" do
    expect(subject.new(filter, opts).opts).to eq(opts)
  end

  it "populates #filters" do
    expect(subject.new.filters).to eq subject::Filters::DEFAULT_FILTERS
  end
end
