require_relative "../support/simplecov"
require "luna/rspec/formatters/checks"
require "content/pipeline"
require "rspec"

Dir[File.expand_path("../../support/**/*.rb", __FILE__)].each do |f|
  require f
end

RSpec.configure do |config|
  config.order = "random"
end
