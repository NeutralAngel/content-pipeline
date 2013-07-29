require "rspec/helper"

describe CoreExtensions::ObjectExt do
  subject do
    described_class
  end

  describe "#to_nokogiri_fragment" do
    it "converts an object to a nokogiri fragment" do
      expect("".to_nokogiri_fragment).to be_kind_of Nokogiri::HTML::DocumentFragment
    end
  end
end
