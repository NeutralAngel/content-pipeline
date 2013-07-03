module RSpec
  def self.root
    Pathname.new(File.expand_path("../../", __FILE__))
  end
end

require_relative '../support/simplecov'
require 'content/pipeline'
require 'rspec'

Dir[RSpec.root.join("support/**/*.rb")].each do |f|
  require_relative f
end

RSpec.configure do |config|
  config.order = 'random'
end
