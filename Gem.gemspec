$:.unshift(File.expand_path('../lib', __FILE__))
require 'content/pipeline/version'

Gem::Specification.new do |spec|
  spec.homepage = 'https://github.com/envygeeks/content-pipeline'
  spec.summary = 'Adds a pipeline for your content.'
  spec.version = Content::Pipeline::VERSION
  spec.name = 'content-pipeline'
  spec.license = 'Apache 2.0'
  spec.require_paths = ['lib']
  spec.authors = 'Jordon Bedwell'
  spec.email = 'envygeeks@gmail.com'
  spec.add_development_dependency('guard-rspec')
  spec.add_development_dependency('rake')
  spec.add_development_dependency('rspec')
  spec.add_development_dependency('coveralls')
  spec.add_development_dependency('simplecov')
  spec.add_development_dependency('kramdown')
  spec.add_development_dependency('redcarpet')
  spec.add_development_dependency('github-markdown')
  spec.add_development_dependency("luna-rspec-formatters")
  spec.files = %w(Readme.md License Rakefile Gemfile) + Dir.glob("lib/**/*")
  spec.description = 'A less restrictive version of html-pipeline for your content.'
end
