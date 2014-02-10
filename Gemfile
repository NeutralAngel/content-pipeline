source "https://rubygems.org"
gemspec

group :development do
  gem "kramdown"
  gem "gemoji"
  gem "rake"

  unless RbConfig::CONFIG["ruby_install_name"] == "jruby"
    gem "pygments.rb"
    gem "github-markdown"
  end
end
