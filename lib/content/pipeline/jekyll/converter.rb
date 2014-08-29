require "content/pipeline"

module Content::Pipeline::Jekyll
  class Converter < Jekyll::Converter
    ContentPipeline = Content::Pipeline.new

    def matches(ext)
      ext =~ /\.(md|markdown)\Z/
    end

    def output_ext(ext)
      ".html"
    end

    def convert(data)
      ContentPipeline.filter(data)
    end
  end
end
