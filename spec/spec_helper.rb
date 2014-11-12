require 'g5/jobbing'
require 'pry'
require 'rspec/its'

module FixturesHelper
  def fixture(fixture_path)
    open(File.join("spec", "fixtures", fixture_path)).read
  end
end

RSpec.configure do |config|
  config.include FixturesHelper
end