require "rspec/helper"

describe Content::Pipeline::Filter do
  subject { Content::Pipeline }

  before :all do
    class DemoFilter1 < Content::Pipeline::Filter
      add_filter({
        :hello1 => :str,
        :hello2 => :str
      })

      def hello1
        @str = @str.to_nokogiri_fragment
      end

      def hello2
        @str = @str.class if @str == "t"
        @str = @str.to_nokogiri_fragment
      end
    end

    class DemoFilter2 < Content::Pipeline::Filter
      add_filter({
        :hello => :nokogiri
      })

      def hello
        @str = @str.class
      end
    end

    class DemoFilter3 < Content::Pipeline::Filter
      add_filter :filter1, :filter2

      def filter1
        return
      end

      def filter2
        @str = "passed"
      end
    end
  end

  let(:filters) do
    [
      DemoFilter1,
      DemoFilter2
    ]
  end

  after :all do
    Object.send(:remove_const, :DemoFilter1)
    Object.send(:remove_const, :DemoFilter2)
  end

  context "non-notified deprecated behavior" do
    context "filter :filter1, :filter2 (old behavior)" do
      it "works" do
        expect(DemoFilter3.filters).to eq [
          [:filter1, :str],
          [:filter2, :str]
        ]

        expect(Content::Pipeline.new([DemoFilter3]).filter(  \
          "failed")).to eq "passed"
      end
    end
  end

  context "filter input type" do
    it "will convert to String unless type != str" do
      expect(subject.new([DemoFilter1]).filter("t")).to \
        eq "String"
    end

    it "will not convert types that are not str" do
      expect(subject.new(filters).filter("hello")).to \
        eq "Nokogiri::HTML::DocumentFragment"
    end
  end

  it "allows you to add ordered filter chains" do
    expect(DemoFilter1.filters).to eq [
      [:hello1, :str],
      [:hello2, :str]
    ]
  end
end
