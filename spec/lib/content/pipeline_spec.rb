require "rspec/helper"

describe Content::Pipeline do
  let(:filter) do
    described_class::Filters::Markdown
  end

  let(:opts) do
    {
      :o1 => 1,
      :o2 => 2
    }
  end

  describe "opts" do
    it "populates" do
      expect(described_class.new(filter, opts).opts).to eq({
        :o1 => 1,
        :o2 => 2
      })
    end
  end

  describe "filters" do
    it "populates customs" do
      expect(described_class.new(filter).filters).to eq [
        filter
      ]
    end

    it "populates defaults" do
      expect(described_class.new.filters).to \
        eq described_class::Filters::DEFAULT_FILTERS
    end

    it "runs" do
      filter.should_receive(:new).with("# Foo", opts).and_call_original
      filter.any_instance.should_receive(:run).and_call_original

      obj = described_class.new(filter, {
        :markdown => {
          :o1 => 1
        }
      })

      expect(obj.filter("# Foo", :markdown => { :o2 => 2 })).to match \
        /<h1[^>]*>Foo<\/h1>/
    end
  end
end
