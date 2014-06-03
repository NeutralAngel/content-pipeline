$:.unshift(File.expand_path("../lib", __FILE__))
require "content/pipeline/version"

Gem::Specification.new do |spec|
  spec.description = "A less restrictive version of html-pipeline for content."
  spec.files = %w(Readme.md License Rakefile Gemfile) + Dir.glob("lib/**/*")
  spec.homepage = "https://github.com/envygeeks/content-pipeline"
  spec.summary = "Adds a pipeline for your content."
  spec.version = Content::Pipeline::VERSION
  spec.name = "content-pipeline"
  spec.license = "Apache 2.0"
  spec.require_paths = ["lib"]
  spec.authors = "Jordon Bedwell"
  spec.email = "envygeeks@gmail.com"

  spec.add_dependency("nokogiri", "~> 1.6")
  spec.add_development_dependency("rspec", "~> 3.0")
  spec.add_development_dependency("envygeeks-coveralls", "~> 0.2")
  spec.add_development_dependency("rspec-collection_matchers", "~> 0.0")
  spec.add_development_dependency("luna-rspec-formatters", "~> 1")
end
