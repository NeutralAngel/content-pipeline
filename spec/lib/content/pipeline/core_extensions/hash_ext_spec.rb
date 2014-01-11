require "rspec/helper"

describe CoreExtensions::HashExt do
  describe "#deep_merge" do
    it "merges a hash" do
      expect({ :a => { :b => 2 }}.deep_merge(:a => 2)).to eq({
        :a => 2
      })
    end

    it "deep merges hashes" do
      expect({ :a => { :b => 2 }}.deep_merge(:a => { :b => 3 })).to eq({
        :a => {
          :b => 3
        }
      })
    end
  end
end
