source 'https://rubygems.org'
gemspec

group :development do
  gem 'kramdown', '~> 1.1.0'
  gem 'pry', '~> 0.9.12'

  unless RbConfig::CONFIG['ruby_install_name'] == 'jruby'
    gem 'pygments.rb', '~> 0.5.1'
    gem 'github-markdown', '~> 0.5.3'
  end
end
