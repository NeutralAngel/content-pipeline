require 'rspec/helper'

describe CoreExtensions::HashExt do
  subject do
    described_class
  end

  describe '#deep_merge' do
    it 'properly deep merges hashes' do
      expect({ :a => { :b => 2 }}.deep_merge({ :a => { :b => 3 }})).to eq :a => { :b => 3 }
    end
  end
end
