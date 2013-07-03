$:.unshift(File.expand_path('../lib', __FILE__))
require 'content/pipeline/version'

Gem::Specification.new do |spec|
  spec.description = 'A less restrictive version of html-pipeline for content.'
  spec.files = %w(Readme.md License Rakefile Gemfile) + Dir.glob("lib/**/*")
  spec.homepage = 'https://github.com/envygeeks/content-pipeline'
  spec.summary = 'Adds a pipeline for your content.'
  spec.version = Content::Pipeline::VERSION
  spec.name = 'content-pipeline'
  spec.license = 'Apache 2.0'
  spec.require_paths = ['lib']
  spec.authors = 'Jordon Bedwell'
  spec.email = 'envygeeks@gmail.com'

  # --------------------------------------------------------------------------
  # Dependencies.
  # --------------------------------------------------------------------------

  spec.add_dependency('nokogiri', '~> 1.6.0')
  spec.add_development_dependency('rake', '~> 10.1.0')
  spec.add_development_dependency('coveralls', '~> 0.6.7')
  spec.add_development_dependency('pygments.rb', '~> 0.5.1')
  spec.add_development_dependency('rspec', '>= 2.14.0.rc1')
  spec.add_development_dependency('github-markdown', '~> 0.5.3')
  spec.add_development_dependency("luna-rspec-formatters", ">= 0.0.1")
end
