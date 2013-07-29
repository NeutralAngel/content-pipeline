source "https://rubygems.org"
gemspec

group :development do
  unless ENV["CI"]
    gem "pry"
  end

  gem "envygeeks-coveralls"
  gem "kramdown"
  gem "rake"
  gem "luna-rspec-formatters"

  unless RbConfig::CONFIG["ruby_install_name"] == "jruby"
    gem "pygments.rb"
    gem "github-markdown"
  end
end
