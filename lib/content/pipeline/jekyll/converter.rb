require "content/pipeline"

module Content::Pipeline::Jekyll
  class Converter < Jekyll::Converter
    CONTENT_PIPELINE = Content::Pipeline.new

    def matches(ext)
      ext =~ /\.(md|markdown)\Z/
    end

    # -------------------------------------------------------------------------

    def output_ext(ext)
      ".html"
    end

    # -------------------------------------------------------------------------
    # It should be noted that MARKDOWN_CONVERTOR uses the default options
    # provided by Content::Pipeline at:
    #   https://github.com/envygeeks/content-pipeline
    # -------------------------------------------------------------------------

    def convert(data)
      CONTENT_PIPELINE.filter(data)
    end
  end
end
