require 'rspec/helper'

describe CoreExtensions::ObjectExt do
  subject do
    described_class
  end

  describe '#require_or_fail' do
    it 'tries to load a and then b' do
      expect_error LoadError do
        self.should_receive(:require).with('a').ordered.and_call_original
        self.should_receive(:require).with('b').ordered.and_call_original
        require_or_fail('a', 'b', 'This is a really long message for you guys.')
      end
    end
  end

  describe '#to_nokogiri_fragment' do
    it 'converts an object to a nokogiri fragment' do
      expect("".to_nokogiri_fragment).to be_kind_of Nokogiri::HTML::DocumentFragment
    end
  end
end
