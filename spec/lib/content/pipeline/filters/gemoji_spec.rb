require "content/pipeline/filters/gemoji"
require "rspec/helper"

describe Content::Pipeline::Filters::Gemoji do
  subject { described_class }

  context "with as_liquid_asset set to true" do
    it "outputs a liquid asset tag" do
      obj = subject.new(":smile:", {
        :as_liquid_asset => true
      })

      expect(obj.run).to eq '{%img "/assets/smile.png" ":smile:" %}'
    end
  end

  context "with a custom tag" do
    it "sends a message to it" do
      obj = subject.new(":smile:", {
        :tag => proc { |p, a|
          "#{p}:#{a}"
        }
      })

      expect(obj.run).to eq "/assets/smile.png:smile"
    end
  end

  context "with a custom asset path" do
    it "uses it" do
      obj = subject.new(":smile:", {
        :asset_path => "/foo-bar"
      })

      obj.run.to_nokogiri_fragment.tap do |o|
        result = o.search(">img")
        expect(result.first.attr(:src)).to eq "/foo-bar/smile.png"
      end
    end
  end

  it "does not go bat-shit crazy and replace all :: stuff" do
    expect(subject.new('<img alt=":smile:">').run).to eq '<img alt=":smile:">'
  end

  it "does Gemoji on multi-line strings" do
    subject.new(":smile:\n:smile:").run.to_nokogiri_fragment.tap do |o|
      expect(results = o.search(">img")).to have(2).items
      results.each do |r|
        expect(r.attr(:alt)).to eq ":smile:"
        expect(r.attr(:src)).to eq "/assets/smile.png"
      end
    end
  end

  it "does Gemoji normal strings" do
    subject.new(":smile:").run.to_nokogiri_fragment.tap do |o|
      expect(result = o.search(">img")).to have(1).item
      expect(result.first.attr(:src)).to eq "/assets/smile.png"
      expect(result.first.attr(:alt)).to eq ":smile:"
    end
  end

  it "does Gemoji on HTML strings" do
    subject.new("<p>:smile:</p>").run.to_nokogiri_fragment.tap do |o|
      expect(result = o.search(">p>img")).to have(1).item
      expect(result.first.attr(:alt)).to eq ":smile:"
      expect(result.first.attr(:src)).to eq "/assets/smile.png"
    end
  end

  it "does Gemoji on horrible HTML strings" do
    subject.new(":smile: <p>:smile:</p>").run.to_nokogiri_fragment.tap do |o|
      expect(result = o.search("img")).to have(2).items
      result.each do |r|
        expect(r.attr(:alt)).to eq ":smile:"
        expect(r.attr(:src)).to eq "/assets/smile.png"
      end
    end
  end
end
